/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import {
  PluginSlot,
  EventManager,
  EvtBus,
  WindowEvent,
  ScreenOnOffEvent,
  EventConstants,
  localEventManager,
  viewMgrPolicy,
  ViewType,
  ConfigurationEvent,
} from '@ohos/frameworkwrapper';
import { LogDomain, Logger } from '@ohos/basicutils';
import { WindowConstants } from '@ohos/commonconstants';
import MeasureText from '@ohos.measure';
import { Constants as StatusbarConstants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';
import { ResUtils, SCBScreenProperty, SCBSceneSessionManager } from '@ohos/windowscene';
import { PcSmartDockStyleManager } from '@ohos/pcsmartdock/src/main/ets/default/common/PcSmartDockStyleManager';
import { MultiKeyCode, MultimodalInputManager, StatusBarType } from '@ohos/systemuicommon';
import { ReceiveEventInfo } from '@ohos/launchercommon';
import {
  QuickToggleController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import type { Configuration } from '@ohos.app.ability.Configuration';
import { PromptAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/PromptAdapter';

import Constants from '../../common/constants';
import { EditModeBarIface, EditModeVisitor, EditModeGridIface } from '../interfaces/EditModeIface';
import { EditModePanelIface } from '../interfaces/EditModeIface';
import { EditModeBarVm } from '../vm/EditModeBarVm';
import { EditModePanelVm } from '../vm/EditModePanelVm';
import { EditModeGridVm } from '../vm/EditModeGridVm';
import { EditModeBarStyle, EditModePromptStyle } from '../style/EditModeStyle';


const TAG = 'EditModeModel';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export interface EditModeInitParam {
  editModeBarVm: EditModeBarVm;
  editModePanelVm: EditModePanelVm;
  editModeSelectedGridVm: EditModeGridVm;
  editModeCandidateGridVm: EditModeGridVm;
  screenProperty: SCBScreenProperty;
}

/**
 * 控制中心编辑面板窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL;

/**
 * 表示值未发生变化
 */
const NOT_CHANGE = -1;

const TOP_WINDOW_SPACE: number = 4;

export class EditModeModel implements EditModeVisitor {
  private lastConfig?: Configuration;
  private lastPanelHeight: number = -1;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenProp: SCBScreenProperty = new SCBScreenProperty();
  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string[]) => {
      this.handleLocalEvent(event, params);
    }
  };
  private editModePanelIface?: EditModePanelIface;
  private editModeBarIface?: EditModeBarIface;
  private editModeSelectedGridIface?: EditModeGridIface;
  private editModeCandidateGridIface?: EditModeGridIface;

  public initEditModeVm(param: EditModeInitParam): void {
    this.screenProp = param.screenProperty;

    this.initEditModePanelVm(param.editModePanelVm);
    this.initEditModeBarVm(param.editModeBarVm);
    this.initEditModeSelectedGridVm(param.editModeSelectedGridVm);
    this.initEditModeCandidateGridVm(param.editModeCandidateGridVm);
    this.initEventMgr();
    this.registerLocalEventListener();
    this.registerTouchOutsideEvent(param);
  }

  public onBtnClickCb(slot: string, isSelected: boolean): void {
    if (!this.editModeSelectedGridIface || !this.editModeCandidateGridIface) {
      log.showError(TAG, `onBtnClickCb ${slot} ${isSelected}, grid iface invalid`);
      return;
    }
    log.showInfo(TAG, `onBtnClickCb ${slot} ${isSelected}`);
    const selectedLength = this.editModeSelectedGridIface.onGetToggleData().length;
    if (this.checkLimitAndShowToast(selectedLength, isSelected)) {
      log.showInfo(TAG, `removeToggle selected grid length: ${selectedLength}`);
      return;
    }
    if (isSelected) {
      this.removeToggle(slot);
    } else {
      this.addToggle(slot);
    }
  }

  /**
   * 从选中库移除图标到备选库
   *
   * @param toggle 图标
   */
  private removeToggle(toggle: string): void {
    let selectedToggles = this.editModeSelectedGridIface!.onGetToggleData(false);
    let candidateToggles = this.editModeCandidateGridIface!.onGetToggleData(false);
    const index = selectedToggles.findIndex((toggleSlot: string) => {
      return toggleSlot === toggle;
    });
    if (index < 0) {
      return;
    }
    animateTo({
      duration: 250,
    }, () => {
      // 移除图标
      selectedToggles.splice(index, 1);
      this.refreshGridLayout(true);
    });
    const toggleCount = QuickToggleController.getInstance().getToggleColumn();
    if (candidateToggles.length % toggleCount === 0) {
      const calHeight = this.editModeCandidateGridIface!.calculateGridHeight(true);
      this.editModeCandidateGridIface!.updateGridLayout({
        height: calHeight,
      });
    }
    candidateToggles.push(toggle);
    this.refreshPanelLayout(true);
  }

  /**
   * 从备选库添加图标到选中库
   *
   * @param toggle 图标
   */
  private addToggle(toggle: string): void {
    let selectedToggles = this.editModeSelectedGridIface!.onGetToggleData(false);
    let candidateToggles = this.editModeCandidateGridIface!.onGetToggleData(false);
    const index = candidateToggles.findIndex((toggleSlot: string) => {
      return toggleSlot === toggle;
    });
    if (index < 0) {
      return;
    }
    animateTo({
      duration: 250,
    }, () => {
      // 移除图标
      candidateToggles.splice(index, 1);
      this.refreshGridLayout(false);
    });
    const toggleCount = QuickToggleController.getInstance().getToggleColumn();
    if (selectedToggles.length % toggleCount === 0) {
      const calHeight = this.editModeSelectedGridIface!.calculateGridHeight(true);
      this.editModeSelectedGridIface!.updateGridLayout({
        height: calHeight,
      });
    }
    selectedToggles.push(toggle);
    this.refreshPanelLayout(true);
  }

  private isAboveMaxLimit(length: number): boolean {
    return length >= Constants.PC_MODE_QUICK_TOGGLE_MAX;
  }

  private isBelowMinLimit(length: number): boolean {
    return length <= Constants.PC_MODE_QUICK_TOGGLE_MIN;
  }

  private checkLimitAndShowToast(length: number, isSelected: boolean): boolean {
    if (this.isAboveMaxLimit(length) && !isSelected) {
      PromptAdapter.showToast(ResUtils.getInnerStringNumS($r('app.string.control_center_edit_panel_tips_max_toggles'),
        Constants.PC_MODE_QUICK_TOGGLE_MAX));
      return true;
    }

    if (this.isBelowMinLimit(length) && isSelected) {
      PromptAdapter.showToast(ResUtils.getInnerStringNumS($r('app.string.control_center_edit_panel_tips_min_toggles'),
        Constants.PC_MODE_QUICK_TOGGLE_MIN));
      return true;
    }
    return false;
  }

  public onTryRollback(): void {
    if (!this.editModeSelectedGridIface || !this.editModeCandidateGridIface) {
      log.showError(TAG, `onTryRollback selected grid exist: ${this.editModeSelectedGridIface === undefined},
      candidate grid exist: ${this.editModeCandidateGridIface === undefined}`);
      return;
    }
    let selectedSnapShot = this.editModeSelectedGridIface.onGetSnapShot();
    let candidateSnapShot = this.editModeCandidateGridIface.onGetSnapShot();
    if (selectedSnapShot.length > 0 || candidateSnapShot.length > 0) {
      this.editModeSelectedGridIface.onUpdateToggleData(selectedSnapShot);
      this.editModeCandidateGridIface.onUpdateToggleData(candidateSnapShot);
      selectedSnapShot.splice(0, selectedSnapShot.length);
      candidateSnapShot.splice(0, candidateSnapShot.length);
      this.refreshLayout();
    }
  }

  public onConfirmCb(): void {
    if (!this.editModeSelectedGridIface || !this.editModeCandidateGridIface) {
      log.showError(TAG, `onConfirmCb selected grid exist: ${this.editModeSelectedGridIface === undefined},
      candidate grid exist: ${this.editModeCandidateGridIface === undefined}`);
      return;
    }
    let selectedSnapShot = this.editModeSelectedGridIface.onGetSnapShot();
    let candidateSnapShot = this.editModeCandidateGridIface.onGetSnapShot();
    selectedSnapShot.splice(0, selectedSnapShot.length);
    candidateSnapShot.splice(0, candidateSnapShot.length);
    log.showInfo(TAG, 'onConfirmCb');
    QuickToggleController.getInstance().saveQuickToggleData(this.editModeSelectedGridIface.onGetToggleData());
  }

  public destroyEditModeVm(): void {
    this.eventMgr.offAll();
    localEventManager.unregisterEventListener(this.localEventListener);
  }

  public updateEditModeGridData(toggleData: string[], isSelected: boolean): void {
    let toggles = toggleData.filter((toggleSlot: string) => {
      return !this.isNeedFilter(toggleSlot, isSelected);
    });
    if (isSelected) {
      this.editModeSelectedGridIface?.onUpdateToggleData(toggles);
    } else {
      this.editModeCandidateGridIface?.onUpdateToggleData(toggles);
    }
  }

  private isNeedFilter(slot: string, isSelected: boolean): boolean {
    const filterSlots = isSelected ? [] : Constants.QUICK_TOGGLE_DELETE_OF_PC_MODE;
    return filterSlots.includes(slot);
  }

  private initEventMgr(): void {
    log.showInfo(TAG, `init controlcenter edit mode window Policy`);
    this.eventMgr
      .on(WindowEvent, (event: WindowEvent) => {
        this.onWindowEvent(event);
      })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent) => {
        this.onScreenOnOffEvent(event);
      })
      .on(ConfigurationEvent, (event: ConfigurationEvent) => {
        this.onConfigurationEvent(event);
      })
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.editModePanelIface?.onHide();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.editModePanelIface?.onHide();
      }));
  }

  private registerTouchOutsideEvent(param: EditModeInitParam): void {
    const id = param.editModePanelVm.getId();
    const systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(id, param.screenProperty.screenId);
    if (!systemSceneSession) {
      log.showError(TAG, `registerTouchOutsideEvent error, system scene not exist`);
      return;
    }
    systemSceneSession.session?.on('touchOutside', () => {
      log.showInfo(TAG, 'onTouchOutside, edit mode panel.');
      this.editModePanelIface?.onHide();
    });
  }

  public refreshLayout(): void {
    this.refreshGridLayout(true);
    this.refreshGridLayout(false);
    this.refreshPanelLayout();
  }

  private refreshGridLayout(isSelected: boolean): void {
    let iface = isSelected ? this.editModeSelectedGridIface : this.editModeCandidateGridIface
    let calHeight = iface?.calculateGridHeight();
    iface?.updateGridLayout({
      height: calHeight
    });
  }

  private refreshPanelLayout(useAnim: boolean = false): void {
    let windowHeight = this.editModeSelectedGridIface?.calculateGridHeight() ?? 0;
    windowHeight += this.editModeCandidateGridIface?.calculateGridHeight() ?? 0;
    windowHeight += EditModeBarStyle.getInstance().height ?? 0;
    windowHeight += px2vp(ResUtils.getConvertNumber(MeasureText.measureTextSize({
      textContent: $r('app.string.edit_mode_panel_prompt'),
      fontSize: EditModePromptStyle.getInstance().size,
      fontFamily: 'HarmonyHeiTi',
      fontWeight: FontWeight.Medium,
      overflow: TextOverflow.Ellipsis,
      textAlign: TextAlign.Center,
      constraintWidth: EditModePromptStyle.getInstance().width,
    }).height));
    windowHeight += ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_prompt_margin_top')) +
      ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_prompt_margin_bottom'));

    let maxHeight = 0;
    let statusBar = viewMgrPolicy.getArea(ViewType.STATUS_BAR);
    const statusBarHeight = statusBar?.height ?? 0;
    const dockHeight = PcSmartDockStyleManager.getStyle(this.screenProp).mDockHeight;
    const statusBarType = AppStorage.get<number>('statusBarType');
    if (StatusBarType.isWindowStyle(statusBarType)) {
      maxHeight = px2vp(this.screenProp.height) - dockHeight - StatusbarConstants.DEFAULT_DOCK_GAP * 2;
    } else {
      maxHeight =
        px2vp(this.screenProp.height) - dockHeight - statusBarHeight - StatusbarConstants.DEFAULT_DOCK_GAP -
          TOP_WINDOW_SPACE;
    }
    const realHeight = maxHeight > windowHeight ? windowHeight : maxHeight;
    if (this.lastPanelHeight === realHeight) {
      log.showError(TAG, `refreshPanelLayout panel height not change, height: ${realHeight}`);
      return;
    }
    this.lastPanelHeight = realHeight;
    this.editModePanelIface?.updatePanelRect({
      left: NOT_CHANGE,
      top: NOT_CHANGE,
      width: NOT_CHANGE,
      height: vp2px(realHeight),
    }, useAnim);
  }

  private registerLocalEventListener(): void {
    const events: string[] = [
      EventConstants.EVENT_JUMP_TO_EDIT_MODE_PAGE,
    ];
    localEventManager.registerEventListener(this.localEventListener, events);
  }

  private handleLocalEvent(event: string, params: string[]): void {
    log.showInfo(TAG, `handleLocalEvent ${event}`);
    switch (event) {
      case EventConstants.EVENT_JUMP_TO_EDIT_MODE_PAGE:
        this.editModeCandidateGridIface?.updateGridVisibility(true);
        this.editModePanelIface?.onStartShow();
        this.editModePanelIface?.onShow();
      default:
        return;
    }
  }

  public onLockScreen(): void {
    log.showInfo(TAG, 'onLockScreen');
    this.editModePanelIface?.onHide();
  }


  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowStartShow()) {
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(WINDOW_NAME)) {
        log.showInfo(TAG, `onWindowEvent ${event.windowName} ${event.eventType} ${event.eventState}`);
        this.editModePanelIface?.onHide();
        this.editModeCandidateGridIface?.updateGridVisibility(false);
      } else {
        this.editModeSelectedGridIface?.onSnapShot();
        this.editModeCandidateGridIface?.onSnapShot();
      }
    }
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      log.showInfo(TAG, 'onScreenOnOffEvent');
      this.editModePanelIface?.onHide();
    }
  }

  /**
   * 属性变化事件
   *
   * @param event 事件
   */
  private onConfigurationEvent(event: ConfigurationEvent): void {
    const config = event.config;
    if (!config) {
      log.showError(TAG, 'onConfigurationEvent config invalid');
      return;
    }
    if (!this.lastConfig) {
      this.lastConfig = config;
    }
    if (this.lastConfig.language !== config.language) {
      this.refreshLayout();
      this.lastConfig = config;
      log.showInfo(TAG, 'onConfigurationEvent language change, refresh layout');
    }
  }

  private initEditModePanelVm(editModePanelVm: EditModePanelVm): void {
    if (this.editModeBarIface) {
      return;
    }
    editModePanelVm.initEditModePanel();
    this.editModePanelIface = editModePanelVm;
    this.editModePanelIface.acceptModeVisitor(this);
  }

  private initEditModeBarVm(editModeBarVm: EditModeBarVm): void {
    if (this.editModeBarIface) {
      return;
    }
    this.editModeBarIface = editModeBarVm;
    this.editModeBarIface.acceptModeVisitor(this);
  }

  private initEditModeSelectedGridVm(editModeGridVm: EditModeGridVm): void {
    if (this.editModeSelectedGridIface) {
      return;
    }
    this.editModeSelectedGridIface = editModeGridVm;
    this.editModeSelectedGridIface.acceptModeVisitor(this);
  }

  private initEditModeCandidateGridVm(editModeGridVm: EditModeGridVm): void {
    if (this.editModeCandidateGridIface) {
      return;
    }
    this.editModeCandidateGridIface = editModeGridVm;
    this.editModeCandidateGridIface.acceptModeVisitor(this);
  }
}