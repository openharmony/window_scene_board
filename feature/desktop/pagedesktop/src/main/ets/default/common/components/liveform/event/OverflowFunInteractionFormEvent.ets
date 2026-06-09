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

import { image } from '@kit.ImageKit';
import { componentUtils } from '@kit.ArkUI';
import {
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil
} from '@ohos/basicutils';
import { OverflowConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { SnapshotType, DragAccessibilityUtils, dragSnapshotHelper } from '@ohos/componenthelper';
import {
  ResourceManager,
  HiSysEventUtil,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { batchUninstallChain, ForwardType } from '@ohos/launchercommon/Index';
import {
  CardItemInfo,
  CloseAppManager,
  CommonConstants,
  desktopItemDraggableManager,
  editModeManager,
  FormCommonUtil,
  GridLayoutItemInfo,
  GridLayoutUtil,
  DesktopItemVibratorManager,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { scbEventExclusiveManager, EventType } from '@ohos/windowscene';
import OverflowFormUtils from '../common/OverflowFormUtils';
import { FormItemRelativeEvent } from '../../form/viewmodel/FormItemRelativeEvent';
import { FormBackboardVm, FormItemRelativeVm, FormMaskVm } from '../../form/viewmodel/FormItemRelativeVm';
import { FormMenuEvent } from '../../form/viewmodel/FormMenuEvent';
import lazy {
  OverflowFormConnectionType,
  OverflowFormDisconnectionType,
  OverflowFormStatus,
  OverflowFormVm,
  ConnectionInfo,
} from '../viewmodel/OverflowFormVm';
import lazy OverflowEventReport from '../common/OverflowEventReport';
import lazy { OverflowViewModel } from '../viewmodel/OverflowViewModel';

const TAG = 'OverflowFunInteractionFormEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OverflowFunInteractionFormEvent extends FormItemRelativeEvent {
  private mOverflowFormVm?: OverflowFormVm;
  private mOverflowFormId: string = '';
  private mRelativeItemId: string = '';
  private mUiContext?: UIContext;
  // 打点相关
  // 在拉起游戏收到回调前，多次进入暂停态，需要记录恢复-暂停时间段之和
  private overflowFormPauseDuration: number = 0;
  // 游戏退出时，记录前一次暂停时间
  private overflowFormLastPauseTime: number = 0;
  // 点击游戏卡片时间
  private clickCardTime: number = 0;
  // 游戏卡片激活时间
  private overflowFormActiveTime: number = 0;
  // 游戏卡片恢复时间
  private overflowFormResumeTime: number = 0;
  // 游戏卡片暂停时间
  private overflowFormPauseTime: number = 0;
  // 玩游戏总时长
  private overflowFormActiveDuration: number = 0;
  private isBaseFormInLongPress: boolean = false;
  private isUpdateSnapshotFailed: boolean = false;
  private isMenuShow: boolean = false;

  constructor(formItemVm: FormItemRelativeVm, formBackVm: FormBackboardVm, formMaskVm: FormMaskVm,
    isOuter: boolean = false) {
    super(formItemVm, formBackVm, formMaskVm, isOuter);
  }

  /**
   * 在 FormItemRelative 中 FormComponentBuilder 对应 touch 事件处理回调
   *
   * @param event 点击事件
   * @param itemId 点击的卡片id
   * @param isInDrag 是否处于拖拽模式
   */
  public handleTouchEvent: Function = (event: TouchEvent, itemId: string, isInDrag: boolean) => {
    this.removeHoverEffect();
    this.onTouchEventHandler(event, itemId, isInDrag);
  };

  /**
   * 卡片配置信息初始化, 当前卡片为游戏卡片，如果此时设备类型为手机时, enabled 恒为 false，阻断卡片向元服务页面透传事件
   *
   * @param formItem 卡片配置信息
   * @param formHeight 卡片高度
   * @param formWidth 卡片宽度
   */
  public initFormInfo(formItem: CardItemInfo, formHeight: number, formWidth: number): void {
    super.initFormInfo(formItem, formHeight, formWidth);
    this.mFormItemVm.isFormEnabled = !DeviceHelper.isPhone();
    log.showInfo(`initFormInfo: isGameForm = true, isFormEnabled: ${this.mFormItemVm.isFormEnabled}`);
    OverflowViewModel.getInstance().registerFunInterOverflowListener(this.mFormItem.cardId, this);
  }

  /**
   * 解注册 Overflow 监听
   */
  public unregisterOverflowListener(): void {
    OverflowViewModel.getInstance().unregisterFunInterOverflowListener(this.mFormItem.cardId);
  }

  public getLiveFormStatus(): OverflowFormStatus {
    let status: OverflowFormStatus = OverflowFormStatus.INACTIVE;
    if (this.mOverflowFormVm) {
      status = this.mOverflowFormVm.overflowFormStatus;
    }
    log.showInfo(`getLiveFormStatus, status: ${status}`);
    return status;
  }

  public handleFormWrapperClickEvent():void {
    this.activateOverflowForm();
  }

  /**
   * 在 FormItemRelative 中 FormComponentBuilder 对应 Click 事件处理回调
   *
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @param formBorderRadius 卡片圆角尺寸
   */
  public activateOverflowForm(): void {
    // 初次点击 mOverflowFormVm 为空，后续由 OverflowFormItem 完成赋值
    if (this.mOverflowFormVm && this.mOverflowFormVm.overflowFormStatus !== OverflowFormStatus.INACTIVE) {
      log.showInfo('activateOverflowForm: not in INACTIVE mode, do not start overflow form');
      return;
    }
    if (AppStorage.get('isNormalDesktopMode') === false) {
      log.showInfo('activateOverflowForm: not in isNormalDesktopMode mode, do not start overflow form');
      return;
    }
    if (AppStorage.get('isDuringStartExitAnimation') === true) {
      log.showInfo('activateOverflowForm: during start or exit animation for app, do not start overflow form');
      return;
    }

    // 初次添加卡片场景, viewModel 为空，所以使用本地状态变量辅助判断
    if (this.isBaseFormInLongPress) {
      log.showInfo('activateOverflowForm: in long press, do not start overflow form');
      return;
    }
    log.showInfo('activateOverflowForm: set isOverflowFormEnable true');
    this.mFormItemVm.isOverflowFormEnable = true;
    this.clickCardTime = new Date().getTime();
  }

  /**
   * FormItemRelative 组件长按事件处理回调，回调触发长按事件阈值 NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU
   */
  public handleLongPressGestureAction(): void {
    log.showInfo('handleLongPressGestureAction, set isBaseFormInLongPress');
    if (this.isActiveOverflowForm()) {
      return;
    }
    this.isBaseFormInLongPress = true;
    super.handleLongPressGestureAction();
  }

  /**
   * FormItemRelative 组件长按事件结束处理回调，回调触发长按事件阈值 NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU
   */
  public handleLongPressGestureActionEnd(): void {
    log.showInfo(`handleLongPressGestureActionEnd: isMenuShow: ${this.isMenuShow}` +
      `, isBaseFormInLongPress: ${this.isBaseFormInLongPress}`);
    if (this.isActiveOverflowForm()) {
      return;
    }
    let canEnableOverflowForm: boolean = !this.isMenuShow && this.isBaseFormInLongPress;
    this.isBaseFormInLongPress = false;
    if (canEnableOverflowForm) {
      this.activateOverflowForm();
    }
  }

  /**
   * 卡片长按震动处理回调, 回调触发长按时间阈值 NumberConstants.LONG_PRESS_VIBRATOR_TIME
   *
   * @param formMenuEvent 卡片菜单时间处理类
   */
  public handleLongPressVibration(formMenuEvent: FormMenuEvent): void {
    log.showInfo(`handleLongPressVibration: isInEditMode: ${editModeManager.isInEditMode()}`);
    if (CheckEmptyUtils.isEmpty(formMenuEvent)) {
      log.showWarn('formMenuEvent is null');
      return;
    }
    if (this.isActiveOverflowForm()) {
      return;
    }
    // 编辑模式 能够卸载的app 通知显示删除按钮
    if (editModeManager.isInEditMode()) {
      let batchItem: GridLayoutItemInfo[] = [this.mFormItem as Object as GridLayoutItemInfo];
      batchUninstallChain.forward(ForwardType.LONG_PRESS, batchItem);
    }
    log.showInfo(`handleLongPressVibration: isPhone: ${DeviceHelper.isPhone()}` +
      `, mIsInFormHotArea: ${this.mFormItemVm.mIsInFormHotArea}` +
      `, isAliveOverflowForm: ${this.isAliveOverflowForm()}`);
    if ((this.mFormItemVm.mIsInFormHotArea || this.isAliveOverflowForm()) &&
      !scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      DesktopItemVibratorManager.getInstance().longPressVibrator(TAG);
      if (this.isActiveOverflowForm() && this.mOverflowFormVm) {
        // 阻塞 onBlur 回调在长按场景无动效切换
        log.showInfo('LongPressGesture set overflow form isInLongPress true');
        this.mOverflowFormVm.isInLongPress = true;
      }
    }
    // 拖拽适配无障碍朗读普通卡片起拖播报
    DragAccessibilityUtils.textAnnouncedForDragStart();
    if (!editModeManager.isInEditMode() && !AppStorage.get<boolean>('isDrag')) {
      formMenuEvent.setMenuShowState(true);
    }
    this.isBaseFormInLongPress = true;
    this.isMenuShow = true;
  }

  /**
   * 卡片 touch 事件触发的缩放动效处理回调
   *
   * @param isZoomOut 是否执行缩小动效
   * @param cardDimension 卡片尺寸
   * @param endScale 缩放终点
   */
  public playLongPressAnimation(isZoomOut: boolean, cardDimension: number, endScale?: number): void {
    if (this.isActiveOverflowForm()) {
      log.showInfo('playLongPressAnimation: is active form, do not play animation');
      return;
    }
    super.playLongPressAnimation(isZoomOut, cardDimension, endScale);
  }

  /**
   * 卡片长按菜单下树时处理回调, 点击使得卡片菜单消失，此时卡片需切换进入暂停态
   */
  public handleMenuDisappear(): void {
    log.showInfo('handleMenuDisappear');
    this.isMenuShow = false;
  }

  /**
   * 处理长按震动结束事件并重置长按状态
   */
  public handleLongPressVibrationEnd(): void {
    log.showInfo('handleLongPressVibrationEnd, reset isBaseFormInLongPress');
    if (this.isActiveOverflowForm()) {
      return;
    }
    super.handleLongPressVibrationEnd();
    this.isBaseFormInLongPress = false;
  }

  /**
   * 判断是否接受对应的手势
   *
   * @param gestureInfo 手势信息
   * @param event 手势事件
   * @returns 是否接受对应的手势
   */
  public onGestureJudgeBegin(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    if (gestureInfo.type === GestureControl.GestureType.DRAG ||
      gestureInfo.type === GestureControl.GestureType.LONG_PRESS_GESTURE) {
      if (this.isActiveOverflowForm()) {
        return GestureJudgeResult.REJECT;
      }
    }
    // 锁定布局及其他不可拖拽场景禁止拖拽
    if (gestureInfo.type === GestureControl.GestureType.DRAG && !desktopItemDraggableManager.getEnableDrag()) {
      return GestureJudgeResult.REJECT;
    }
    return GestureJudgeResult.CONTINUE;
  }

  /**
   * Overflow 卡片停止溢出并更新溢出状态
   */
  public stopOverflowForm(): void {
    this.switchOverflowState(OverflowFormStatus.INACTIVE, Visibility.Hidden);
  }

  /**
   * Overflow 卡片暂停溢出并更新溢出状态
   */
  public pauseOverflowForm(): void {
    this.switchOverflowState(OverflowFormStatus.PAUSE, Visibility.Visible);
  }

  /**
   * Overflow 卡片开始溢出并更新溢出状态
   */
  public startOverflowForm(): void {
    if (!this.mOverflowFormVm) {
      log.showInfo('startOverflowForm, viewModel is not valid');
      return;
    }
    this.mOverflowFormVm.overflowFormStatus = OverflowFormStatus.ACTIVE;
    this.mOverflowFormVm.overflowFormVisibilityStatus = Visibility.Visible;
    this.mOverflowFormVm.overflowPauseVisibilityStatus = Visibility.Hidden;
    this.mOverflowFormVm.overflowMaskVisibilityStatus = Visibility.Hidden;
    this.setBaseFormVisibility();
    AppStorage.setOrCreate('activeForm', this.mFormItem as Object as GridLayoutItemInfo);
    let requestForm: ConnectionInfo = {
      connectType: OverflowFormConnectionType.USER_CLICK,
      formId: this.mFormItem.cardId
    };
    AppStorage.setOrCreate<ConnectionInfo>(OverflowConstants.CONNECTION_INFO, requestForm);
  }

  /**
   * 更新 Overflow 卡片的加载状态
   *
   * @param value 是否加载 Overflow 卡片
   */
  public updateOverflowFormEnableStatus(value: boolean): void {
    if (this.mFormItemVm) {
      this.mFormItemVm.isOverflowFormEnable = value;
    }
  }

  /**
   * 更新渲染组中控制按钮的状态
   *
   * @param value 控制按钮是否在渲染组中
   */
  public updateControlButtonInRenderGroupStatus(value: boolean): void {
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.isControlButtonInRenderGroup = value;
    }
  }

  /**
   * Overflow 卡片初始化时，向 event 同步最新属性
   *
   * @param overflowFormVm Overflow 卡片 ViewModel 相关属性
   * @param formComponentBuilderId Overflow 卡片截图层 id
   * @param context OverflowForm 组件上下文
   * @param overflowFormId ExtensionComponent 组件 id
   * @param relativeItemId FormItemRelative 组件 id
   */
  public updateOverflowFormConfig(overflowFormVm: OverflowFormVm, formComponentBuilderId: string,
    context: UIContext, overflowFormId: string, relativeItemId: string): void {
    this.mOverflowFormVm = overflowFormVm;
    this.mFormComponentBuilderId = formComponentBuilderId;
    this.mOverflowFormId = overflowFormId;
    this.mRelativeItemId = relativeItemId;
    this.mUiContext = context;
  }

  /**
   * 获取 Overflow 卡片恢复时间并上报恢复事件
   */
  public getOverflowFormResumeTime(): void {
    log.showInfo('getOverflowFormResumeTime');
    this.overflowFormResumeTime = new Date().getTime();
    this.overflowFormPauseDuration = this.overflowFormPauseDuration +
      (this.overflowFormResumeTime - this.overflowFormPauseTime);
    OverflowEventReport.reportResumeOverflowCardEvent(this.mFormItem,
      this.overflowFormResumeTime, this.overflowFormPauseDuration);
  }

  /**
   * 记录 Overflow 卡片的激活时间
   */
  public getOverflowFormActiveTime(): void {
    this.overflowFormActiveTime = new Date().getTime();
  }

  /**
   * 记录并上报 Overflow 卡片启动信息
   */
  public recordLaunchOverflowCardInfo(): void {
    if (!this.mOverflowFormVm) {
      log.showError(`recordLaunchOverflowCardInfo, mOverflowFormVm is undefined, formId:${this.mFormItem.cardId}`);
      return;
    }
    log.showInfo('recordLaunchOverflowCardInfo');
    let currentTime: number = new Date().getTime();
    let loadDuration: number = currentTime - this.clickCardTime - this.overflowFormPauseDuration;
    let initDuration: number = this.overflowFormActiveTime - this.clickCardTime;
    let interval: number = OverflowConstants.INIT_INTERVAL;
    if (this.overflowFormLastPauseTime !== 0) {
      interval = currentTime - this.overflowFormLastPauseTime;
      this.overflowFormLastPauseTime = 0;
    }
    if (interval > OverflowConstants.OVERFLOW_FORM_PAUSE_TOTAL_DURATION) {
      interval = OverflowConstants.INIT_INTERVAL;
    }
    OverflowEventReport.reportLaunchOverflowCardEvent(this.mFormItem, interval, initDuration,
      loadDuration, this.mOverflowFormVm.overflowFormConnectionType);
  }

  /**
   * 处理触摸事件
   *
   * @param event 触摸事件
   * @param itemId 表单项ID
   * @param isInDrag 是否处于拖拽状态
   */
  public onTouchEventHandler(event: TouchEvent, itemId: string, isInDrag: boolean): void {
    if (CheckEmptyUtils.isEmpty(event)) {
      log.showWarn('touch event is null');
      return;
    }
    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      log.showWarn('form item touch in exclusive scene!');
      return;
    }
    super.onTouchEventHandler(event, itemId, isInDrag);
    if (event.type === CommonConstants.TOUCH_TYPE_MOVE && this.mFormItemVm.isOverflowFormEnable &&
      this.isUpdateSnapshotFailed && !isInDrag) {
      this.isUpdateSnapshotFailed = false;
      this.dragSnapshotHandler(itemId, itemId, isInDrag);
    }
  }

  /**
   * 处理拖拽结束事件
   * 重置长按状态
   */
  public handlerDragEnd(): void {
    if (this.isActiveOverflowForm()) {
      return;
    }
    super.handlerDragEnd();
    this.isBaseFormInLongPress = false;
    log.showInfo(`handlerDragEnd: reset long press status after drag, isBaseFormInLongPress: ` +
      `${this.isBaseFormInLongPress}, OverflowForm is long press : ${this.mOverflowFormVm?.isInLongPress}`);
  }

  /**
   * 设置普通卡片的可见性状态
   */
  public setBaseFormVisibility(): void {
    this.mFormItemVm.formVisibilityStatus = this.mOverflowFormVm ?
      this.mOverflowFormVm.overflowMaskVisibilityStatus : Visibility.Visible;
  }

  /**
   * 更新长按状态
   *
   * @param value 是否处于长按状态
   */
  public updateLongPressStatus(value: boolean): void {
    log.showInfo(`updateLongPressStatus isBaseFormInLongPress: ${this.isBaseFormInLongPress}` +
      `, isInLongPress: ${this.mOverflowFormVm?.isInLongPress}, value: ${value}`);
    this.isBaseFormInLongPress = value;
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.isInLongPress = value;
    }
  }

  /**
   * 处理 overflow 卡片暂停事件并上报
   */
  public handlePauseOverflowCardEvent(): void {
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.isControlButtonInRenderGroup = true;
    }
    this.overflowFormPauseTime = new Date().getTime();
    let interval: number = this.overflowFormPauseTime -
      Math.max(this.overflowFormResumeTime, this.overflowFormActiveTime);
    this.overflowFormActiveDuration = this.overflowFormActiveDuration + interval;
    OverflowEventReport.reportPauseOverflowCardEvent(this.mFormItem, interval);
  }

  /**
   * 处理 overflow 卡片断开连接事件并上报
   */
  public handleDisconnectOverflowCardEvent(): void {
    if (!this.mOverflowFormVm) {
      log.showError(`handleDisconnectGameCardEvent, mOverflowFormVm is undefined, formId:${this.mFormItem.cardId}`);
      return;
    }
    let interval: number = 0;
    // 激活态直接进入非激活态，距上一次暂停态持续时间为0
    if (this.overflowFormPauseTime !== 0) {
      interval = (new Date().getTime()) - this.overflowFormPauseTime;
    }
    this.overflowFormLastPauseTime = this.overflowFormPauseTime; // 前一次暂停时间点
    OverflowEventReport.reportDisconnectOverflowCardEvent(this.mFormItem, interval,
      this.mOverflowFormVm.overflowFormDisconnectionType, this.overflowFormActiveDuration);
    if (this.mOverflowFormVm.overflowFormDisconnectionType !== OverflowFormDisconnectionType.ABNORMAL_EXIT) {
      // 如果是非异常断开，则将记录的暂停时间赋值为0
      this.overflowFormLastPauseTime = 0;
    }
    this.overflowFormActiveTime = 0;
    this.overflowFormPauseTime = 0;
    this.overflowFormResumeTime = 0;
    this.overflowFormPauseDuration = 0;
  }

  protected dragSnapshotHandler(itemId: string, cacheId: string, isInDrag: boolean): void {
    if (!this.mFormItemVm || !this.mFormItemVm.isOverflowFormEnable) {
      log.showInfo(`do super dragSnapshotHandler, isOverflowFormEnable: ${this.mFormItemVm.isOverflowFormEnable}`);
      super.dragSnapshotHandler(itemId, cacheId, isInDrag);
      return;
    }

    // 当 isInDrag 为 True 时候，表示组件正在处理拖拽的状态，此时执行截图会有两个问题:
    // 1. FormComponent 组件此时 visibility 状态未 Hidden，对齐父组件截图无法得到正确内容
    // 2. 在拖拽结束之后，现有 snapshot 会执行 release 动作
    // 所以在这种场景下，将截图动作延迟到 MOVE 过程中执行
    if (isInDrag && !this.isUpdateSnapshotFailed) {
      log.showInfo('dragSnapshotHandler: isInDrag status, do not get snapshot');
      this.isUpdateSnapshotFailed = true;
      return;
    }
    let snapshotId: string = this.mFormComponentBuilderId === '' ? itemId : this.mFormComponentBuilderId;
    log.showInfo(`dragSnapshotHandler: snapshotFromId: ${snapshotId}, ${cacheId}`);
    TraceUtil.startTrace(DomainName.HOME, `snapshotFromId:${this.mFormComponentBuilderId}`);
    dragSnapshotHelper.snapshotUntilRenderFinishedFromId(snapshotId, SnapshotType.BOTH,
      GridLayoutUtil.generateUniqueKey(this.mFormItem as Object as GridLayoutItemInfo),
      (value: image.PixelMap) => {
        this.updateDragImage?.(value);
        ResourceManager.getInstance().setAppResourceCache(cacheId, 'cardSnapshot', value);
        CloseAppManager.getInstance().setCardStartSnapshot(cacheId, value);
        TraceUtil.endTrace(DomainName.HOME, `snapshotFromId:${snapshotId}`);
        log.showInfo(`dragSnapshotHandler: snapshotFromId ${cacheId} ok`);
      });
  }

  /**
   * 处理长按震动取消事件并重置长按状态
   */
  public handleLongPressVibrationCancel(): void {
    if (this.isActiveOverflowForm()) {
      return;
    }
    log.showInfo('handleLongPressVibrationCancel, reset isBaseFormInLongPress');
    this.isBaseFormInLongPress = false;
  }

  /**
   * 处理长按手势取消事件并重置长按状态
   */
  public handleLongPressGestureActionCancel(): void {
    if (this.isActiveOverflowForm()) {
      return;
    }
    log.showInfo('handleLongPressGestureActionCancel, reset isBaseFormInLongPress');
    this.isBaseFormInLongPress = false;
  }

  private isAliveOverflowForm(): boolean {
    return this.isActiveOverflowForm() || this.isPauseOverflowForm();
  }

  private isActiveOverflowForm(): boolean {
    if (!this.mOverflowFormVm) {
      return false;
    }
    return this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE;
  }

  private isPauseOverflowForm(): boolean {
    if (!this.mOverflowFormVm) {
      return false;
    }
    return this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE;
  }

  private switchOverflowState(status: OverflowFormStatus, pauseVisibility: Visibility) {
    if (!this.mOverflowFormVm) {
      log.showInfo('switchState, viewModel is not valid');
      return;
    }
    OverflowFormUtils.setActiveFormTouch(false);
    this.mOverflowFormVm.overflowFormStatus = status;
    this.mOverflowFormVm.overflowPauseVisibilityStatus = pauseVisibility;
    this.mOverflowFormVm.overflowFormVisibilityStatus = Visibility.Hidden;
    this.mOverflowFormVm.overflowMaskVisibilityStatus = Visibility.Visible;
    this.setBaseFormVisibility();
    let activeForm: GridLayoutItemInfo | undefined = AppStorage.get<GridLayoutItemInfo>('activeForm');
    if (activeForm?.cardId === this.mFormItem.cardId) {
      AppStorage.setOrCreate('activeForm', undefined);
    }
    let userRequestForm: ConnectionInfo =
      AppStorage.get<ConnectionInfo>(OverflowConstants.CONNECTION_INFO) ?? new ConnectionInfo();
    if (userRequestForm.formId === this.mFormItem.cardId) {
      AppStorage.setOrCreate<ConnectionInfo>(OverflowConstants.CONNECTION_INFO, new ConnectionInfo());
    }
  }

  /**
   * 加载扩展 Want 参数
   *
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @param formBorderRadius 卡片圆角
   */
  public loadExtWant(formItemWidth: number, formItemHeight: number, formBorderRadius: number): void {
    let formItemId: string = FormCommonUtil.getFormComponentId(this.mFormItem);
    let windowOffset = componentUtils.getRectangleById(this.mFormComponentBuilderId).windowOffset;
    log.showInfo(`loadFunInteractionExtWant: formItemId ${formItemId}` +
      `, mFormItemWidth: ${formItemWidth}|${vp2px(formItemWidth)}` +
      `, mFormItemHeight: ${formItemHeight}|${vp2px(formItemHeight)}` +
      `, mFormBorderRadius: ${formBorderRadius}`);
    if (!this.mOverflowFormVm) {
      log.showInfo('loadFunInteractionExtWant, overflowFormVm is not ready');
      return;
    }
    if (this.mFormItem.gameCardInfo && CheckEmptyUtils.checkStrIsEmpty(this.mFormItem.gameCardInfo.formBindAbility)) {
      this.mFormItem.gameCardInfo.formBindAbility = OverflowConstants.FORM_BIND_ABILITY_DEFAULT;
    }
    log.showInfo(`formBundle: ${this.mFormItem.bundleName}, formBindGame: ${this.mFormItem.gameCardInfo?.formBindGame},
      subBundleName: ${this.mFormItem.gameCardInfo?.subBundleName}
      formBindAbility: ${this.mFormItem.gameCardInfo?.formBindAbility}}`)
    if (this.mFormItem.gameCardInfo?.gameType !== OverflowConstants.QUICK_TYPE_GAMECARD &&
      this.mFormItem.gameCardInfo?.extensionType !== OverflowConstants.INTERACTION_TYPE) {
      log.showWarn('loadFunInteractionExtWant. Invalid interaction type: %{public}s',
        this.mFormItem.gameCardInfo?.extensionType);
      return;
    }

    this.mOverflowFormVm.uiExtWant = {
      bundleName: HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME,
      abilityName: this.mFormItem.gameCardInfo?.formBindAbility,
      parameters: {
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'launchOption': {
          'gameInfo': {
            'packageName': this.mFormItem.gameCardInfo?.formBindGame,
            'independentSubPkgName': this.mFormItem.gameCardInfo?.subBundleName,
            'type': 1
          },
          'extraInfo': {
            'formInfo': {
              'formId': this.mFormItem.cardId,
              'bundleName': this.mFormItem.bundleName,
              'rect': [windowOffset.x, windowOffset.y, formItemWidth, formItemHeight],
              'screenSize': [AppStorage.get<number>('screenWidth'), AppStorage.get<number>('screenHeight')],
              'radius': formBorderRadius,
            }
          }
        }
      }
    }
  }

  public isOverflowFormEnable(): boolean {
    return this.mFormItemVm.isOverflowFormEnable;
  }

  public isInOverflow(): boolean {
    return false;
  }

  public handleFormStatusChange(): void {}
}