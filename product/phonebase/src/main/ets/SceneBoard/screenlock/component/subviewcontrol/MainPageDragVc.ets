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

import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { SlViewController } from '@ohos/screenlockcommon/Index';
import { PerformanceMonitorUtil, screenLockInnerStateManager, ScreenLockState } from '@ohos/screenlockcommon';
import { clockLayoutHelper, GridAmount } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  SlBindStateType,
  SlMainStateType,
  SlSubStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import { MpEventType, MpStateType, MpStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { curves } from '@kit.ArkUI';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { clockLayoutParam } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockLocateState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockLocateState';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import { SCBScreenProperty, SCBScreenSessionManager, } from '@ohos/windowscene/src/main/ets/TsIndex';
import { SlBindState } from '../../model/data/SlBindState';
import { FormStartPosition } from '@ohos/screenlockwidget/src/main/ets/form/remote/FormCallbackStub';
import FormProxy from '@ohos/screenlockwidget/src/main/ets/form/remote/FormProxy';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import FormPlaceHolderInfo from '@ohos/screenlockwidget/src/main/ets/form/drag/FormPlaceHolderInfo';
import { MainPageVc } from '../../controller/MainPageVc';
import { ScreenLockAniParam } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniData';
import { screenLockAniMgr, ScreenLockAniScene } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniMgr';
import { slStateHelper } from '@ohos/screenlockwidget/src/main/ets/common/utils/SlStateHelper';
import { LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

const TAG = 'MainPageDragVc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const CLOCK_MARGIN_TOP: number = 99;
const CLOCK_UP_DISTANCE: number = -65;
const CARD_POSITION_TAG: string = 'ScreenLockFormPanel';

// 动效场景，时钟拖拽
const ANIM_SCENE_DRAG = 'anim_scene_drag';

/**
 * View Control里用于操作渲染界面的对象
 */
export interface DragOperateParams {
  persistentId: number;
  slBindState: SlBindState;
  slClockBindCtrl: SlClockBindState;
  slClockLocateState: SlClockLocateState;
  clockStyle: AnyClock;
  startInfo: TranslateOptions;
  dragInfo: TranslateOptions;
  holderInfo: FormPlaceHolderInfo;
  mainPageVc: MainPageVc;
  formViewModel: ScreenLockFormViewModel;
}

/**
 * 时钟拖拽view controller
 */
export class MainPageDragVc extends SlViewController<MpStateType> {
  private persistentId: number;
  private slBindState: SlBindState;
  private slClockBindCtrl: SlClockBindState;
  private slClockLocateState: SlClockLocateState;
  private clockStyle: AnyClock;
  private startInfo: TranslateOptions;
  private dragInfo: TranslateOptions;
  private holderInfo: FormPlaceHolderInfo;
  private mainPageVc: MainPageVc;
  private formViewModel: ScreenLockFormViewModel;
  private mpState: MpStateType = MpStateType.INIT_STATE;
  private slObserverProxy: SlObserverProxy = new SlObserverProxy();
  // 当前是否正在拖拽
  private isDragging: boolean = false;

  private initMpFsmState(): void {
    this.mpState = this.slObserverProxy.getMpFsmState(this.persistentId,
      (oldState: MpStateType, newState: MpStateType): void => {
      if (oldState === newState) {
        return;
      }
      this.mpState = newState;
      if (MpStateTypeUtils.isEditState(oldState) && !MpStateTypeUtils.isEditState(newState)) {
        this.resetClockDragData();
      }
      if (MpStateTypeUtils.isEditFullState(newState)) {
        if (oldState === MpStateType.EDIT_CARD_DETAIL_STATE &&
          newState !== MpStateType.EDIT_CARD_DETAIL_STATE) {
          this._formProxy.closeFormManager();
        }
      }
    });
  }

  /**
   * 锁屏状态变化监听
   */
  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType !== SlBindStateType.SL_CLOCK_DRAG_STATE || !this.slBindState.getClockDragState()) {
        return;
      }
      if (!MpStateTypeUtils.isEditFullState(this.mpState)) {
        return;
      }
      log.showInfo(`Clock Drag`);
      // 艺术签名拖拽开始
      this.isDragging = true;
      animateTo({
        duration: 300,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      }, () => {
        this.slClockBindCtrl?.setLayoutScale(1.05);
      })
    }
  };

  constructor(params: DragOperateParams) {
    super();
    this.persistentId = params.persistentId;
    this.slBindState = params.slBindState;
    this.slClockBindCtrl = params.slClockBindCtrl;
    this.slClockLocateState = params.slClockLocateState;
    this.clockStyle = params.clockStyle;
    this.startInfo = params.startInfo;
    this.dragInfo = params.dragInfo;
    this.holderInfo = params.holderInfo;
    this.mainPageVc = params.mainPageVc;
    this.formViewModel = params.formViewModel;
  }

  /**
   * 执行初始化
   */
  protected doInit(_params?: DragOperateParams): void {
    this.initMpFsmState();
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
    super.doInit(_params);
  }

  /**
   * 执行释放
   */
  protected doRelease(): void {
    super.doRelease();
    this.slObserverProxy.release();
    slUiStateMgr.unregisterSlStateChangeListener(this.slStaticStateListener);
  }

  public handleClockDrag(event: TouchEvent): void {
    if (!this.clockStyle || !MpStateTypeUtils.isEditState(this.mpState)) {
      log.showDebug('handleClockDrag invalid param');
      return;
    }
    let isN4Layout: boolean = clockLayoutHelper.isN4Layout(this.clockStyle.layout);
    let xCorrection: number = this.clockStyle.x;
    let yCorrection: number = this.clockStyle.y;

    if (event.type === TouchType.Down) {
      this.handleClockDragStart(event);
    }

    if (event.type === TouchType.Move && this.slBindState.getClockDragState()) {
      this.handleClockDragMove(event, xCorrection, yCorrection);
    }

    if ((event.type === TouchType.Up || event.type === TouchType.Cancel) && this.slBindState.getClockDragState() &&
      event.touches.length <= 1) {
      const isMoved = this.handleClockDragEnd();
      if (!isMoved) {
        return;
      }
    }
  }

  private handleClockDragStart(event: TouchEvent): void {
    this.startInfo = {
      x: event.touches[0].displayX,
      y: event.touches[0].displayY
    }
  }

  private handleClockDragMove(event: TouchEvent, xCorrection: number, yCorrection: number): void {
    this.dragInfo.x = event.touches[0].displayX - ((this.startInfo?.x ?? 0) as number);
    this.dragInfo.y = event.touches[0].displayY - ((this.startInfo?.y ?? 0) as number);


    let gridWidth = this.slBindState.getGridWidth();
    let dragX = 0;
    let dragY = 0;
    if (gridWidth !== 0) {
      dragX = Math.round(((this.dragInfo.x ?? 0) as number) / gridWidth);
      dragY = Math.round(((this.dragInfo.y ?? 0) as number) / gridWidth);
    } else {
      log.showWarn('handleClockDragMove error: division by zero');
    }

    let gridAmount: GridAmount = clockLayoutHelper.getLayoutAmount(this.isPortrait(), this.isFoldExpanded());
    let formPanelHeight: number = this.formViewModel ? this.formViewModel.getCurrentPanelHeight() : 0;

    let fixedDragX = this.getFixedDrag(dragX, -xCorrection, gridAmount.x -
    clockLayoutParam.gridParam.gridWidthAmount - xCorrection);
    let fixedDragY = this.getFixedDrag(dragY, -yCorrection, gridAmount.y -
    clockLayoutParam.gridParam.gridHeightAmount - formPanelHeight - yCorrection);

    animateTo({
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      duration: 350
    }, () => {
      this.slClockLocateState.setDragGridX(fixedDragX);
      this.slClockLocateState.setDragGridY(fixedDragY);
    })
  }

  private setDragPostion(dragGridX: number, dragGridY: number): void {
    this.slClockLocateState.setDragGridX(dragGridX);
    this.slClockLocateState.setDragGridY(dragGridY);
  }

  private handleClockDragEnd(): boolean {
    // 标记拖拽结束
    this.isDragging = false;
    this.slBindState.setClockDragState(false);
    screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL);
    let x: number = this.slClockLocateState.getDragGridX();
    let y: number = this.slClockLocateState.getDragGridY();

    animateTo({
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS, 228, 30),
      onFinish: () => {
        this.setDragPostion(0, 0);
      }
    }, () => {
      this.resetClockDragData();
      if (this.clockStyle) {
        this.clockStyle.x += x;
        this.clockStyle.y += y;
      }
    })

    // 若发生了移动，x或者y不为0，返回true
    return x !== 0 || y !== 0;
  }

  private resetClockDragData(): void {
    this.slClockBindCtrl?.setLayoutScale(1);
    this.setDragPostion(0, 0);
    this.dragInfo.x = 0;
    this.dragInfo.y = 0;
  }



  private isShowFormBindSheet: boolean = false;
  private isEditClockUp: boolean = false;
  private dragStartOffset?: FormStartPosition;
  private formAnimationKey?: string;
  private animationEndCallback?: Callback<void>;
  private readonly _formProxy: FormProxy = new FormProxy(GlobalContext.getContext(), {
    exitFormCenter: () => {
      log.showInfo('exitFormCenter');
      if (!MpStateTypeUtils.isEditState(this.mpState)) {
        this.animationEndCallback = undefined;
        return;
      }
      if (this.slBindState.getClockDragState()) {
        log.showInfo(`Clock Drag`);
        return;
      }
      if (!this.animationEndCallback) {
        ScreenLockFsmProxy.getInstance(this.persistentId).submitMainPageEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
        return;
      }
      this.animationEndCallback = undefined;
      this.handleFormDragFinish();
      ScreenLockFsmProxy.getInstance(this.persistentId).submitMainPageEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
    },

    addForm: (cardInfo?: CardItemInfo, startPosition?: FormStartPosition) => {
      log.showInfo(`addForm cardInfo: ${JSON.stringify(cardInfo)}, startPosition: ${JSON.stringify(startPosition)}`);
      if (!cardInfo || !startPosition) {
        return;
      }
      this.formAnimationKey = `${cardInfo.cardName}_${cardInfo.tempId}`;
      let scbScreenProperty: SCBScreenProperty = SCBScreenSessionManager.getInstance()
        .getMainScreenSession()?.scbScreenProperty;
      let index = this.formViewModel.addScreenLockForm(cardInfo, 6);
      if (index < 0) {
        return;
      }
      this.mainPageVc.getViewModel()?.setAddFormState(true);
      let card: LockscreenFormConfig = this.formViewModel.formConfigs[index];
      this.holderInfo = FormPlaceHolderInfo.buildForm(false, card, this.holderInfo);
      if (RTLUtil.isRTL()) {
        if (scbScreenProperty) {
          startPosition.x = px2vp(scbScreenProperty.width) - startPosition.x;
        }
      }
      let endPosition: Position = this.getAddFormEndPosition(scbScreenProperty, index);
      this.animationEndCallback = () => {
        screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL_FORM);
      }

      let param: ScreenLockAniParam = {
        startPosition: startPosition,
        endPosition: endPosition,
        color: this.mainPageVc.getAestheticColorArgs().isChangeColor ? this.clockStyle.clockStrokeColor : '#ffffff',
        isLightWallpaper: this.mainPageVc.getClockNeedToDarken(),
        scaleX: this.slBindState.getEditClockUpScale(),
        scaleY: this.slBindState.getEditClockUpScale(),
      }
      this._formProxy.playDropAnimation(this.formAnimationKey ?? '', param);
    },

    onDragStart: (cardInfo?: CardItemInfo, startPosition?: FormStartPosition) => {
      log.showInfo('onDragStart');
      if (!cardInfo) {
        return;
      }
      this.mainPageVc.getViewModel()?.setDragFormState(true);
      this.dragStartOffset = startPosition;
      this.formAnimationKey = `${cardInfo.cardName}_${cardInfo.tempId}`;
      let index = this.formViewModel.addScreenLockForm(cardInfo, 6, true);
      if (index < 0) {
        return;
      }
      this.animationEndCallback = () => {
        screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL_FORM);
      }
      this.slBindState.setIsFormDragNotDrop(true);
      this.holderInfo = FormPlaceHolderInfo.buildForm(true, this.formViewModel.formConfigs[index], this.holderInfo);
      screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FORM_DRAG);
    },

    enterFormManager: (cardInfo?: CardItemInfo) => {
      log.showInfo('enterFormManager');
      PerformanceMonitorUtil.reportLockscreenEditMoreCard(cardInfo?.bundleName);
      ScreenLockFsmProxy.getInstance(this.persistentId).submitMainPageEvent(MpEventType.ENTER_EDIT_CARD_DETAIL);
    },

    enterFormCenter: () => {
      log.showInfo('enterFormCenter');
      if (this.slBindState.getIsFormDragNotDrop()) {
        return;
      }
      ScreenLockFsmProxy.getInstance(this.persistentId).submitMainPageEvent(MpEventType.ENTER_EDIT_CARD);
    },

    onAnimationEnd: () => {
      log.showInfo('onAnimationEnd');
      this.handleFormDragFinish();
    },

    onDragEnd: () => {
      log.showInfo('onDragEnd');
      if (!this.slBindState.getIsFormDragNotDrop()) {
        this.mainPageVc.getViewModel()?.setDragFormState(false);
        return;
      }
      this.handleFormDragFinish();
    }
  });

  private getAddFormEndPosition(scbScreenProperty : SCBScreenProperty, index : number): Position {
    let formConfig = this.formViewModel.getFormConfigInfo()[index];
    let positionIndex = `${CARD_POSITION_TAG}_${formConfig.positionX}_${formConfig.positionY}`;
    let cardRectInfo: RectInfo = ItemUtils.getRectById(positionIndex);
    return {
      x: RTLUtil.isRTL() && scbScreenProperty ?
        px2vp(scbScreenProperty.width) - (px2vp(scbScreenProperty.width) / 2 +
          this.slBindState.getEditClockUpScale() / 2 * (cardRectInfo.left + cardRectInfo.right -
          px2vp(scbScreenProperty.width))) :
        px2vp(scbScreenProperty.width) / 2 +
          this.slBindState.getEditClockUpScale() / 2 * (cardRectInfo.left + cardRectInfo.right -
          px2vp(scbScreenProperty.width)),
      y: this.slBindState.getEditClockUpScale() * (cardRectInfo.top + cardRectInfo.bottom) / 2
    }
  }

  private handleFormDragFinish() {
    log.showInfo('handleFormDragFinish');
    this.slBindState.setIsFormDragNotDrop(false);
    this.mainPageVc.getViewModel()?.setAddFormState(false);
    this.mainPageVc.getViewModel()?.setDragFormState(false);
    this.cancelAddingFormAni();
    this.holderInfo = FormPlaceHolderInfo.buildDefault(this.holderInfo);
    if (!MpStateTypeUtils.isEditState(this.mpState)) {
      this.animationEndCallback = undefined;
      return;
    }
    this.handleEditorFinish();
  }

  private handleEditorFinish() {
    this.animationEndCallback?.();
    this.animationEndCallback = undefined;
    if (!this.isShowFormBindSheet) {
      this._formProxy.disConnect();
    }
  }

  public cancelAddingFormAni(): void {
    let key: string = `${this.holderInfo.dragForms?.formInfo.cardName}_${this.holderInfo.dragForms?.formInfo.tempId}`;
    screenLockAniMgr.cancelAnimation(ScreenLockAniScene.BIND_SHEET, key);
  }

  public getFormProxy(): FormProxy {
    return this._formProxy;
  }

  public handleFormDragStart(event: DragEvent): void {
    log.showInfo('handleFormDragStart');
    this.startInfo = {
      x: event.getDisplayX(),
      y: event.getDisplayY()
    }
  }

  public handleFormDragMove(event: DragEvent): void {
    if (!MpStateTypeUtils.isEditState(this.mpState)) {
      this.holderInfo.newX = undefined;
      this.holderInfo.newY = undefined;
      return;
    }
    let formPosition: FormStartPosition = this.getFormPanelPosition();
    let newX: number = Math.floor((event.getDisplayX() - formPosition.x) / this.slBindState.getGridWidth());
    let newY: number = Math.floor((event.getDisplayY() - formPosition.y) / this.slBindState.getGridWidth());
    let height: number = this.formViewModel.getFormPanelHeight();
    this.holderInfo.newX = this.getFixedDrag(newX, height - 1, 5 - height - this.holderInfo.dimensionX);
    this.holderInfo.newY = this.getFixedDrag(newY, 0, height - 1);
  }

  public handleFormDragEnd(event: DragEvent): void {
    log.showInfo('handleFormDragEnd');
    let scbScreenProperty: SCBScreenProperty = SCBScreenSessionManager.getInstance()
      .getMainScreenSession()?.scbScreenProperty;
    this.slBindState.setIsFormDragNotDrop(false);
    this.mainPageVc.getViewModel()?.setAddFormState(false);
    this.mainPageVc.getViewModel()?.setDragFormState(false);
    event.useCustomDropAnimation = true;
    if (!this.holderInfo.dragForms) {
      return;
    }
    let index = this.formViewModel.getFormIndex(this.holderInfo.dragForms);
    if (index < 0) {
      log.showWarn('handleFormDragEnd invalid index');
      return;
    }
    let offsetX: number = this.dragStartOffset?.x ?? 0
    let offsetY: number = this.dragStartOffset?.y ?? 0
    let startPosition: Position = {
      x: RTLUtil.isRTL() && scbScreenProperty ? px2vp(scbScreenProperty.width) - (event.getDisplayX() + offsetX) :
        event.getDisplayX() + offsetX,
      y: event.getDisplayY() + offsetY
    };
    let endPosition = this.getAddFormEndPosition(scbScreenProperty, index);
    let param: ScreenLockAniParam = {
      startPosition: startPosition,
      endPosition: endPosition,
      color: this.mainPageVc.getAestheticColorArgs().isChangeColor ? this.clockStyle.clockStrokeColor : '#ffffff',
      isLightWallpaper: this.mainPageVc.getClockNeedToDarken(),
      scaleX: this.slBindState.getEditClockUpScale(),
      scaleY: this.slBindState.getEditClockUpScale(),
    }
    if (!!this.animationEndCallback) {
      this._formProxy.playDropAnimation(this.formAnimationKey ?? '', param);
    } else {
      let key: string = `${this.holderInfo.dragForms?.formInfo.cardName}_${this.holderInfo.dragForms?.formInfo.tempId}`;
      screenLockAniMgr.playAnimation(ScreenLockAniScene.INNER, key, param, () => {
        this.holderInfo = FormPlaceHolderInfo.buildDefault(this.holderInfo);
        this.animationEndCallback = undefined;
        screenLockInnerStateManager.onEnterFullEditor(this.formViewModel.editStatusBeforeDrag);
      });
    }
  }

  public updateDragState(isShowFormBindSheet: boolean): void {
    this.isShowFormBindSheet = isShowFormBindSheet;
    if (!isShowFormBindSheet) {
      if (!this.animationEndCallback && !this.slBindState.getIsFormDragNotDrop()) {
        this._formProxy.disConnect();
      }
    }
  }

  public updateClockEditTop(isEditClockUp: boolean) {
    this.isEditClockUp = isEditClockUp;
  }

  private getFormPanelPosition(): FormStartPosition {
    let formY: number = CLOCK_MARGIN_TOP + (this.isEditClockUp ? CLOCK_UP_DISTANCE :
    this.mainPageVc.getScreenLockPanelPositionY()) + clockLayoutParam.gridParam.gridHeightAmount *
      this.slBindState.getGridWidth();
    let formX: number = clockLayoutHelper.getHorizontalGridMargin(this.isPortrait()) +
      (this.mainPageVc.getScreenLockPanelPositionX() + this.getFormPositionX()) * this.slBindState.getGridWidth();
    let endPosition = this.getScalePosition(formX, formY);
    return {
      x: endPosition.x,
      y: endPosition.y
    };
  }

  private getScalePosition(originX: number, originY: number): FormStartPosition {
    let scbScreenProperty: SCBScreenProperty = SCBScreenSessionManager.getInstance()
      .getMainScreenSession()?.scbScreenProperty;
    return {
      // 显示半模态时，时钟卡片缩放的中心点位(this.screenProp.width / 2, 0)
      x: originX * this.slBindState.getEditClockUpScale() + (1 - 
        this.slBindState.getEditClockUpScale()) * px2vp(scbScreenProperty.width / 2),
      y: originY * this.slBindState.getEditClockUpScale()
    };
  }

  private getFormPositionX(): number {
    let positionX: number = clockLayoutHelper.isN4Layout(this.clockStyle.layout) ? 0 : -1;
    let clockPositionX = this.mainPageVc.getScreenLockPanelPositionX();
    let layoutWidth = clockLayoutHelper.getLayoutAmount(this.isPortrait(), this.isFoldExpanded()).x;
    let isLimit = this.formViewModel.supportFormPositions.length > 0 &&
      this.formViewModel.supportFormPositions[0].positionX === 0;
    if (isLimit && positionX + clockPositionX > layoutWidth - 4) {
      positionX = -2;
    }
    return positionX;
  }

  private getFixedDrag(drag: number, min: number, max: number): number {
    if (drag > max) {
      return max;
    } else if (drag < min) {
      return min;
    } else {
      return drag;
    }
  }
}