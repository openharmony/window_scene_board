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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  AccessibilityUtil,
  CacheValue,
  GlobalStatusCache,
  ISlStateChangeListener,
  KeyGuardPage,
  KeyguardStatusService,
  PerformanceMonitorUtil,
  SlSubStateType
} from '@ohos/screenlockcommon';
import {
  ArtLayoutBindStateType,
  EditBindStateType,
  EditStaticStateType,
  SlMainStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { LockscreenEditApplyParams } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import ScreenLockThemeManager, {
  CONFIG_VERSION,
} from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import {
  AnyClock,
  CLOCK_DEFAULT_FOREGROUND_COLOR
} from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import MultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import ThemeHelperUtil from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import {
  ClockInnerConfig,
  LockscreenConfig,
  LockscreenForm,
  LockscreenFormConfig,
} from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { ThemeRemoteManager } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeRemoteManager';
import { CoreEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { MpEventType, MpStateType, MpStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { GestureEnableCaller, ResUtils, scbGestureManager } from '@ohos/windowscene';
import { ClockViewVc } from '../component/subviewcontrol/ClockViewVc';
import { SlBindState } from '../model/data/SlBindState';
import { slStateHelper } from '../model/helper/SlStateHelper';
import { slEditorHelper } from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/EditSheetHelper';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { LockscreenThemeConfig } from '@ohos/screenlockwidget';
import ScreenLockFormPanelMeshConfig from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelMeshConfig';

const TAG = 'ScreenLockEditViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const PREFERENCES_NAME: string = 'ScreenlockAIGC';

/**
 * 锁屏编辑页面管理类
 *
 * @since 2024-03-12
 */
export class ScreenLockEditVm {
  private mFormViewModel: ScreenLockFormViewModel;
  private currentClockStyle: AnyClock;
  private mThemeManager: ThemeRemoteManager = new ThemeRemoteManager();
  private originClockStyle: AnyClock = new AnyClock();
  private originFormConfigInfo: LockscreenFormConfig[] = [];
  private originFormPositionY: number = 0;
  private shouldRevert: boolean = false;
  public isClockVisible: boolean = true;
  private lockscreenConfig: LockscreenConfig = new LockscreenConfig();
  private themeId: CacheValue = GlobalStatusCache.getInstance().getStatus('editThemeId', '');
  private themeName: CacheValue = GlobalStatusCache.getInstance().getStatus('editThemeName', '');
  private persistentId: number = 0;
  public isSaveConfig: boolean = false;
  private slBindState: SlBindState = slStateHelper.getSlBindState();
  private curMpState: MpStateType = MpStateType.INIT_STATE;

  private onArtLayoutStateChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_ART_LAYOUT_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType !== ArtLayoutBindStateType.SL_EDIT_ART_PANEL) {
        return;
      }

      if (MpStateTypeUtils.isEditClockState(this.curMpState)) {
        // 艺术签名切换样式时，需要隐藏布局面板
        ScreenLockFsmProxy.getInstance(this.persistentId).submitMainPageEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
      }
    }
  }

  constructor(formViewModel: ScreenLockFormViewModel, clockStyle: AnyClock) {
    this.mFormViewModel = formViewModel;
    this.currentClockStyle = clockStyle;
  }

  public initViewModel(persistentId: number = 0) {
    this.persistentId = persistentId;
    slEditorHelper.getLayoutEditManger().init();
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockEditStateManger()
      .registerSlStateChangeListener(this.onArtLayoutStateChange);
    log.info('initViewModel persistentId:' + persistentId);
  }

  public destroyViewModel(): void {
    slEditorHelper.getLayoutEditManger().destroy();
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockEditStateManger()
      .unregisterSlStateChangeListener(this.onArtLayoutStateChange);
  }

  public setCurMpState(value: MpStateType) {
    this.curMpState = value;
  }

  public updateMpFsmState(oldState: MpStateType, newState: MpStateType): void {
    if (MpStateTypeUtils.isEditPreviewState(newState)) {
      // 初始化VDE定制参数管理类
      this.onEnterThemeEditor(oldState, newState);
    } else if (MpStateTypeUtils.isUnlockState(newState)) {
      if (this.shouldRevert) {
        this.revertThemeInfo();
      }
    } else if (!MpStateTypeUtils.isEditState(newState) && !MpStateTypeUtils.isBouncerState(newState)) {
      this.onEnterHost(oldState, newState);
    }
  }


  private onEnterThemeEditor(oldState: MpStateType, newState: MpStateType): void {
    log.showInfo('onEnterThemeEditor');
    KeyguardStatusService.switchToPage(KeyGuardPage.THEME_EDIT_PAGE);
    this.saveOriginThemeInfo();
    this.isClockVisible = ThemeHelperUtil.getLockManifest().clockVisible;
    scbGestureManager.setGestureNavigationEnablePriority(GestureEnableCaller.SCREEN_LOCK, true, true);
    this.useSendAccessibility(oldState, newState);
  }

  private onEnterHost(oldState: MpStateType, newState: MpStateType): void {
    log.showInfo('onEnterHost');
    if (!this.isSaveConfig && this.shouldRevert) {
      this.revertThemeInfo();
    }
    this.shouldRevert = false;
    this.isSaveConfig = false;
    this.useSendAccessibility(oldState, newState);
  }

  /**
   * 使用无障碍播报能力
   *
   * @param preState 锁屏状态
   *
   */
  private useSendAccessibility(oldState: MpStateType, newState: MpStateType): void {
    let constantsMsg: Resource | undefined = undefined;
    if (!MpStateTypeUtils.isEditState(oldState) && MpStateTypeUtils.isEditState(newState)) {
      constantsMsg =
        Constants.ENTER_EDIT_ACCESSIBLE;
    } else if (MpStateTypeUtils.isEditClockState(oldState) && MpStateTypeUtils.isEditPreviewState(newState)) {
      constantsMsg = Constants.EXIT_CLOCK_EDIT_ACCESSIBLE;
    } else if (MpStateTypeUtils.isEditState(oldState) && !MpStateTypeUtils.isEditState(newState)) {
      constantsMsg =

        Constants.EXIT_EDIT_ACCESSIBLE;
    }
    if (constantsMsg) {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerString(constantsMsg));
    }
  }

  /**
   * 点击退出编辑
   */
  public cancelEdit(newState: MpStateType): void {
    if (this.isDragMode()) {
      return;
    }
    if (MpStateTypeUtils.isEditFullState(newState)) {
      log.showInfo('cancel to guide');
      ScreenLockFsmProxy.getInstance(this.persistentId)
        .submitMainPageEvent(MpEventType.EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK);
    } else if (MpStateTypeUtils.isEditPreviewState(newState)) {
      log.showInfo('cancel to host');
      this.isSaveConfig = false;
      ScreenLockFsmProxy.getInstance(this.persistentId).submitCoreEvent(CoreEventType.EXIT_EDIT);
    } else {
      log.showInfo('error cancel');
    }
    PerformanceMonitorUtil.reportLockscreenEditCancel();
  }

  /**
   *  是否处于拖拽模式
   */
  public isDragMode(): boolean {
    return this.slBindState.getClockDragState() || this.slBindState.getIsFormDragNotDrop();
  }

  /**
   * 还原进入编辑模式前的主题信息
   */
  public revertThemeInfo(): void {
    log.showInfo('revert theme info');
    this.shouldRevert = false;
    if (MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      MultiSceneThemeManager.revertThemeInfoOnExitEditor();
      const origThemeInfo: LockscreenThemeConfig =
        MultiSceneThemeManager.getCurSceneThemeInfo() as LockscreenThemeConfig;
      slStateHelper.getSlClockStaticState()?.setChangeColorState(
        origThemeInfo.clock.color !== CLOCK_DEFAULT_FOREGROUND_COLOR);
    } else {
      this.currentClockStyle?.deepClone(this.originClockStyle);
      this.mFormViewModel.initFormConfigInfo(this.originFormConfigInfo);
      this.mFormViewModel.formPanelPositionY = this.originFormPositionY;
      slStateHelper.getSlLockIconBindState()
        .setChangeColor(this.originClockStyle.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR);
      this.mFormViewModel.updatePanelHeight();
      ScreenLockFormPanelMeshConfig.setPanelHeight(this.mFormViewModel.getFormPanelHeight());
    }
    let colorIndex = slEditorHelper.getTargetColorIndex(this.currentClockStyle.clockStrokeColor);
    slUiStateMgr.getSlState(SlMainStateType.SL_EDIT_BIND_STATE)?.setSlState(EditBindStateType.SELECTED_COLOR_INDEX,
      colorIndex);
    // 异壁纸场景下，originClockStyle始终为默认值，不能使用其属性值
    if (MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      slStateHelper.getSlClockStaticState()?.setChangeColorState(
        MultiSceneThemeManager.getCurClockStyle()?.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR);
    } else {
      slStateHelper.getSlClockStaticState()?.setChangeColorState(
        this.originClockStyle.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR);
    }
    // 通知外部取消编辑
    slUiStateMgr.getSlState(SlMainStateType.SL_EDIT_STATIC_STATE)?.setSlState(EditStaticStateType.IS_CANCEL_EDIT, true);
  }

  /**
   * 更新应用主题信息
   */
  public applyThemeConfig(): void {
    if (this.isDragMode()) {
      return;
    }
    log.showInfo('applyThemeConfig');
    this.shouldRevert = false;
    this.originFormConfigInfo = [];
    this.updateThemeStyle();
    if (MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      MultiSceneThemeManager.updateEditorCacheThemeInfo(this.lockscreenConfig.form);
      this.mThemeManager.setMultiSceneThemeCfg(MultiSceneThemeManager.getMultiSceneThemeEditCfg());
    } else {
      this.mThemeManager.setCurrentThemeCfg(this.lockscreenConfig);
    }
    this.isSaveConfig = true;
    slStateHelper.getSlLockIconBindState()
      .setChangeColor(this.currentClockStyle.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR);
    ScreenLockFsmProxy.getInstance(this.persistentId).submitCoreEvent(CoreEventType.EXIT_EDIT);
    ScreenLockThemeManager.getInstance().notifyUpdateCardStyle(JSON.stringify({
      fontFamily: this.currentClockStyle.clockFontFamily,
      mainTextWeight: ClockStaticData.getTimeFontWeightStr(this.currentClockStyle.clockFontFamily),
    }));
    ClockViewVc.updateComponentMeshConfig(this.currentClockStyle);
  }

  /**
   * 清空编辑面板
   */
  public clearEditor(): void {
    log.showInfo('clearEditor');
    ScreenLockFsmProxy.getInstance(this.persistentId).submitMainPageEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
  }

  protected saveOriginThemeInfo(): void {
    if (this.shouldRevert) {
      return;
    }
    this.shouldRevert = true;
    if (MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      MultiSceneThemeManager.initEditorThemeInfo();
    } else {
      this.originFormConfigInfo = [];
      log.showInfo(`originFormConfigInfo = ${this.originFormConfigInfo.length} formConfigs = ${this.mFormViewModel.formConfigs.length}`)
      this.originClockStyle = ObjectCopyUtil.deepClone(this.currentClockStyle, new AnyClock());
      this.mFormViewModel.formConfigs.forEach((formInfo: LockscreenFormConfig) => {
        this.originFormConfigInfo.push(ObjectCopyUtil.deepClone(formInfo, new LockscreenFormConfig()));
      })
      this.originFormPositionY = this.mFormViewModel.formPanelPositionY;
    }
  }

  // 获取卡片总占位宫格数
  private getCardsLength(): number {
    let cardsLength: number = 0;
    if (this.lockscreenConfig.form.list.length !== 0) {
      this.lockscreenConfig.form.list.forEach((formItem: LockscreenFormConfig) => {
        if (formItem.dimensionX !== 0) {
          cardsLength += formItem.dimensionX;
        }
      });
    }
    log.showInfo(`getCardsLength cardsLength ${cardsLength}`);
    return cardsLength;
  }

  protected updateThemeStyle(): void {
    let newClockConfig: ClockInnerConfig = new ClockInnerConfig();
    newClockConfig.positionX = this.currentClockStyle.x;
    newClockConfig.positionY = this.currentClockStyle.y;
    newClockConfig.layout = this.currentClockStyle.layout;
    newClockConfig.textAlign = this.currentClockStyle.alignment;
    newClockConfig.textShadow = this.currentClockStyle.isClockTextShadowEnabled;
    newClockConfig.textBlurEffect = this.currentClockStyle.isClockTextBlurEffectEnabled;
    newClockConfig.editStatus = false;
    newClockConfig.color = this.currentClockStyle.clockStrokeColor;
    newClockConfig.isDof = this.currentClockStyle.isDof;
    newClockConfig.aestheticColorArgs = this.currentClockStyle.aestheticColorArgs;
    if (newClockConfig.aestheticColorArgs && !newClockConfig.aestheticColorArgs?.isChangeColor) {
      newClockConfig.aestheticColorArgs.isChangeColor =
        this.currentClockStyle.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR;
    }
    newClockConfig.isLightWallpaper = this.currentClockStyle.isLightWallpaper;
    newClockConfig.signatureVisible = this.currentClockStyle.isClockSignatureVisible;
    newClockConfig.clockDegree = this.currentClockStyle.clockDegreeNumber;
    newClockConfig.version = CONFIG_VERSION;
    let lockscreenConfig: LockscreenConfig = new LockscreenConfig();
    let formConfig: LockscreenForm = new LockscreenForm();
    formConfig.list = this.mFormViewModel.getFormConfigInfo();
    formConfig.positionY = this.mFormViewModel.getPanelPositionY();
    // 保存锁屏时钟
    lockscreenConfig.clock = newClockConfig;
    // 保存锁屏卡片
    lockscreenConfig.form = formConfig;
    this.lockscreenConfig = lockscreenConfig;
    GlobalStatusCache.getInstance().setStatus('editFormNum', formConfig.list.length.toString());
    GlobalStatusCache.getInstance().setStatus('editDimensionNum', this.getCardsLength().toString());
    let editApplyParams: LockscreenEditApplyParams = {
      timeLayout: this.currentClockStyle.layout.toString(),
      timeFont: newClockConfig.fontFamily ?? '',
      timeColor: this.currentClockStyle.clockStrokeColor,
      showDate: Number(this.currentClockStyle.isClockDateVisible).toString(),
      showLunarCalendar: Number(this.currentClockStyle.isClockLunarVisible).toString(),
      showSignature: Number(this.currentClockStyle.isClockSignatureVisible).toString(),
      formNum: formConfig.list.length.toString(),
      dimensionNum: this.getCardsLength().toString(),
      themeId: this.themeId.toString(),
      themeName: this.themeName.toString()
    }
    log.showInfo(`update theme style, layout:${lockscreenConfig.clock.layout}, ` +
      `x:${lockscreenConfig.clock.positionX}, y:${lockscreenConfig.clock.positionY}`);
    PerformanceMonitorUtil.reportLockscreenEditApply(editApplyParams, newClockConfig);
  }
}