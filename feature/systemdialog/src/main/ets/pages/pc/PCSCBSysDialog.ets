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

import { sensor } from '@kit.SensorServiceKit';
import { display } from '@kit.ArkUI';
import { LogDomain, Logger } from '@ohos/basicutils';
import { EventConstants } from '@ohos/launchercommon/src/main/ets/constants/EventConstants';
import { windowManager } from '@ohos/componentdrag';
import { DeviceHelper, EventManager, EvtBus, localEventManager } from '@ohos/frameworkwrapper';
import {
  BackPressPriority,
  baseStateMgr,
  IState,
  OnStateChangeListener,
  StateType,
  SysDialogType
} from '@ohos/systemuiutils';
import SystemDialogController from '../../controller/Controller';
import { DialogDataEvent, IParameters, ISystemDialogData, ReceiveEventInfo } from '../../common/DialogDataEvent';
import { SystemDialogEventUtil, SystemDialogState } from '../../common/SysDialogEventUtil';
import { ResourceUtil } from '../../common/ResourceUtil';
import { PCSysDialogManager } from './PCSysDialogManager';
import {
  SysDialogZOrder,
  UiExtNodeAngle,
  GestureState,
  GestureConstant,
  RotateState,
  SysDialogParamsKey
} from '../../common/Constants';

const TAG = 'PCSCBSysDialog';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const DIALOG_CLEAR_TIMEOUT: number = 5000;
//Frequency reported by the sensor, in nanoseconds.
const SENSOR_INTERVAL: number = 100000000;

@Component
export struct PCSCBSysDialog {
  /**
   * 面板ID
   */
  @Prop persistentId: number;
  /**
   * 屏幕ID
   */
  @Prop screenId: number;
  /**
   * 面板序号
   */
  @Prop zorder: SysDialogZOrder;
  /**
   * 面板类型
   */
  @Prop viewTypeKey: SysDialogType;
  /**
   * 三方系统弹框数据集
   */
  @State list: Array<ISystemDialogData> = [];
  /**
   * 是否为轴事件:当前仅在由鼠标滚轮或者触控板双指滑动场景下触发的Pan手势中可以获取
   */
  private isAxisEvent: boolean = false;
  /**
   * 事件管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private sysDialogMgrPC: PCSysDialogManager = new PCSysDialogManager(this.viewTypeKey, this.screenId);
  /**
   * 弹框数据刷新回调事件
   */
  private onDialogDataEvent = (event: DialogDataEvent) => {
    let sysDialogZOrder = event.dialogZOrder;
    let list = event.dataList;
    const sList = list.filter(o => o.screenId === this.screenId && o.sysDialogZOrder === this.zorder);
    if (sysDialogZOrder === this.zorder) {
      this.processDialogData(event);
      this.list = sList;
      log.showWarn(TAG, `sysDialogZOrder:${this.zorder} list.length:${list.length} ` +
        `${JSON.stringify(sList.map(o => 'screenId:' + o.screenId + ':' + o.want.bundleName))}`);
      if (this.list.length) {
        this.sysDialogMgrPC.requestPanelOuter();
      } else {
        // when hide, the following registerUnfocusedCallback will be triggered
        this.sysDialogMgrPC.releasePanelOuter();
      }
    }
  };

  /**
   * 根据业务传递参数处理不同的场景
   */
  private processDialogData(event: DialogDataEvent) {
    const zOrder = event.dialogZOrder;
    const list = event.dataList;
    const item = event.item;
    const upperList = zOrder === SysDialogZOrder.UPPER ? list : event.upperList;
    const defaultList = zOrder === SysDialogZOrder.DEFAULT ? list : event.defaultList;
    log.showInfo(TAG, `processDialogData l:${list.length} d:${defaultList.length} u:${upperList.length} zOrder:${zOrder}`);
    this.setGyroRotationState([...defaultList, ...upperList]);
    this.setGestureState(defaultList, upperList);
    SystemDialogEventUtil.reportSystemDialogEvent(
      SystemDialogEventUtil.EVENT_NAME, item as ISystemDialogData, SystemDialogState.GESTURE);
  }

  /**
   * 设置旋转状态(只要有一个弹窗禁止旋转,则所有弹窗都禁止旋转)
   * @param list 高低层级弹窗集合
   */
  private setGyroRotationState(list: ISystemDialogData[] = []) {
    const sysDialogController = SystemDialogController.getInstance();
    const data = sysDialogController.filterListByKey(list, SysDialogParamsKey.isEnableRotate, RotateState.DISABLE);
    // 有则禁止
    const isEnableRotate = data?.length ? false : true;
    log.showInfo(TAG, `setGyroRotationState ${isEnableRotate}`);
    this.sysDialogMgrPC.setEnableRotate(isEnableRotate);
  }

  /**
   * 设置手势状态
   */
  private setGestureState(defaultList: ISystemDialogData[] = [], upperList: ISystemDialogData[] = []) {
    // 获取所有弹窗中最上层的弹窗
    let lastDialog: ISystemDialogData | undefined = undefined;
    if (upperList.length > 0) {
      lastDialog = upperList?.[upperList.length - 1];
    } else if (defaultList.length > 0) {
      lastDialog = defaultList?.[defaultList.length - 1];
    }

    // 设置最后一个弹窗的手势
    if (lastDialog) {
      const lastWantParameters = lastDialog?.want?.parameters as IParameters;
      const isEnableStatusBarGesture = lastWantParameters?.isEnableStatusBarGesture === GestureState.ENABLE;
      const isEnableBackGesture = lastWantParameters?.isEnableBackGesture === GestureState.ENABLE;
      log.showInfo(TAG, `setGestureState lastWantParameters gesture state: ${isEnableStatusBarGesture} ${isEnableBackGesture}`);
      this.sysDialogMgrPC.setGestureState(isEnableStatusBarGesture, isEnableBackGesture);
    } else {
      log.showInfo(TAG, `setGestureState no lastDialog`);
      this.sysDialogMgrPC.setGestureState(true, true);
    }
  }

  aboutToAppear() {
    log.showInfo(TAG, `aboutToAppear zorder:${this.zorder} screenId:${this.screenId} ${this.persistentId} `);
    SystemDialogController.getInstance().setStatusByScreenId(this.screenId, true);
    // 系统弹框统一管理
    this.sysDialogMgrPC?.appear(this.persistentId);

    // 弹框数据刷新事件
    this.eventMgr.on(DialogDataEvent, this.onDialogDataEvent);
    // 监听PC通知事件触发弹窗兜底
    localEventManager.registerEventListener(this.localEventListener,
      [EventConstants.EVENT_FORCE_CLOSE_ALL_SYS_DIALOG]);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear zorder:${this.zorder} screenId:${this.screenId} ${this.persistentId}`);
    SystemDialogController.getInstance().setStatusByScreenId(this.screenId, false);
    this.eventMgr.offAll();
    localEventManager.unregisterEventListener(this.localEventListener);
    this.sysDialogMgrPC?.disappear();
  }

  private localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string) => {
      const length = this.list?.length;
      log.showWarn(TAG, `receive event: ${event}, length: ${length}`);
      if (event === EventConstants.EVENT_FORCE_CLOSE_ALL_SYS_DIALOG && length) {
        SystemDialogController.getInstance().clearAll();
      }
    }
  }

  private isFastUpSwiper(event: GestureEvent): boolean {
    const ret = Math.abs(event.offsetX) < Math.abs(event.offsetY) && event.velocityY < GestureConstant.SWIPE_SPEED;
    log.showInfo(TAG, 'isFastUpSwiper velocityY: %{public}d, ret: %{public}s', event.velocityY, ret);
    return ret;
  }

  private onActionStartEvent = (event: GestureEvent): void => {
    const abilityName = this.list?.map(o => o?.want?.abilityName)?.toString();
    // 轴事件(鼠标滚轮,触摸版本的双指滑动) 不同时为0, 手指触摸屏幕则都为0
    const axisHorizontal = event?.axisHorizontal;
    const axisVertical = event?.axisVertical;
    this.isAxisEvent = axisHorizontal !== 0 || axisVertical !== 0;
    log.showWarn(TAG, `onActionStartEvent ${abilityName} H:${axisHorizontal} V:${axisVertical}`);
  }

  private onActionEndEvent = (event: GestureEvent): void => {
    if (this.isAxisEvent) {
      // 轴事件情况下直接返回
      log.showWarn(TAG, `onActionEndEvent isAxisEvent ${this.isAxisEvent}`);
      return
    }
    // 获取屏幕高度
    const windowHeight = windowManager.getWindowHeight();
    // 当前移动的Y坐标
    const currentY = event?.fingerList[0]?.displayY - event?.offsetY;
    // 底部高度
    const bottomHeight = windowHeight - currentY;
    // 是否从底部开始上滑
    const isFromBottom = bottomHeight < GestureConstant.HOT_AREA_HEIGHT;
    log.showWarn(TAG, `onActionEndEvent isFromBottom ${isFromBottom}`);
    if (!isFromBottom) {
      return
    }
    // 是否快速滑动
    const isFastUpSwiper = this.isFastUpSwiper(event);
    // 偏移量
    const offsetY = Math.abs(event?.offsetY);
    // 是否关闭弹框
    const isNeedClose = offsetY > GestureConstant.PAN_DISTANCE || isFastUpSwiper;
    log.showWarn(TAG, `onActionEndEvent isNeedClose ${isNeedClose}`);
    if (isNeedClose) {
      SystemDialogController.getInstance().clearAll();
    }
    log.showInfo(TAG, 'onActionEndEvent (%{public}d, %{public}d), bottom: %{public}d offsetY: %{public}d',
      event.offsetX, event.offsetY, bottomHeight, offsetY);
  }

  build() {
    if (this.list.length > 0) {
      Stack() {
        ForEach(
          this.list,
          (item: ISystemDialogData, index?: number) => {
            Item({
              index,
              item,
              isEnableBackGesture: (item?.want?.parameters as IParameters)?.isEnableBackGesture === GestureState.ENABLE,
              viewTypeKey: this.viewTypeKey,
              screenId: this.screenId,
              sysDialogMgrPC: this.sysDialogMgrPC
            })
          },
          (item: ISystemDialogData, index) => `${item.id}-${item?.want?.abilityName}-${item.timestamp}`
        )
      }
      .width('100%')
      .height('100%')
      .gesture(
        // 绑定拖动手势
        PanGesture({ distance: GestureConstant.TOUCH_SLOP, direction: PanDirection.Up })
          .onActionStart(this.onActionStartEvent)
          .onActionEnd(this.onActionEndEvent)
      )
    }
  }
}

@Component
struct Item {
  @Prop index: number;
  @Prop screenId: number;
  @Prop item: ISystemDialogData;
  @Prop isEnableBackGesture: boolean;
  @Prop viewTypeKey: SysDialogType;
  @Prop sysDialogMgrPC: PCSysDialogManager;
  // Add for AuthWidget rotate on 5.0, and removed on 6.0
  displayHeight: number = 0;
  displayWidth: number = 0;
  rotateAngle: string | number = 0;
  rotateHeight: Length = '100%';
  rotateWidth: Length = '100%';
  rotateCenterX: string | number = 0;
  rotateCenterY: string | number = 0;
  translateX: number = 0;
  translateY: number = 0;
  private mProxy: UIExtensionProxy | null = null;
  @State isFold: boolean = false;
  @State isKeyboardOn: boolean = false;
  @State isOrientationLandscape: boolean = false;
  /**
   * 超时任务Flag
   */
  timeoutFlag: number = 0;

  // 注册透传手势监听器
  private registerBackPressListener() {
    log.showInfo(TAG, `registerBackPressListener`);
    this.sysDialogMgrPC?.registerBackPressListener(this.onBackPressListener, BackPressPriority.PRIORITY_SHUTDOWN);
  }

  // 取消注册透传手势监听器
  private unregisterBackPressListener() {
    log.showInfo(TAG, `unregisterBackPressListener`);
    this.sysDialogMgrPC?.unregisterBackPressListener(this.onBackPressListener);
  }

  // 返回键回调
  private onBackPressListener = (type?: SysDialogType): boolean => {
    log.showInfo(TAG, `onBackPressListener start`);
    if (this.mProxy && this.isEnableBackGesture) {
      log.showInfo(TAG, `onBackPressListener send`);
      this.mProxy?.send({ isGestureBack: true, message: 'handle gesture back successfully' });
      log.showInfo(TAG, `onBackPressListener send done ${type}`);
      return false;
    }
    return true;
  }

  private onFoldStatusChangeListener = (status: display.FoldStatus): void => {
    this.isFold = this.isFoldedOrHalf();
    log.showInfo(TAG, `fold status change to: ${status}`);
  }

  private refreshOrientation(): void {
    try {
      const orientation: display.Orientation = display.getDefaultDisplaySync().orientation;
      if (orientation === display.Orientation.LANDSCAPE || orientation === display.Orientation.LANDSCAPE_INVERTED) {
       this.isOrientationLandscape = true;
       return;
      }
    } catch (err) {
      log.showError(TAG, `refreshOrientation failed. error: ${err?.code} ${err?.message}`);
    }
    this.isOrientationLandscape = false;
  }

  private preProcessFromFoldDevice(): void {
    if (!DeviceHelper.isBigScreenMachine()) {
      return;
    }
    // 显示前获取当前折叠状态
    this.isFold = this.isFoldedOrHalf(); // 注册折叠监听
    try {
      display.on('foldStatusChange', this.onFoldStatusChangeListener);
      this.registerKeyboardState();
      this.refreshOrientation();
      baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onDisplaySizeChange);
      log.showInfo(TAG, `refreshOrientation preProcessFromFoldDevice isOrientationLandscape: ${this.isOrientationLandscape}`);
    } catch (error) {
      log.showError(TAG, `register fold status change listener failed: ${error?.code}`);
    }
  }

  private onDisplaySizeChange: OnStateChangeListener = {
    onStateChange: (state: IState): void => {
      switch (state.getStateType()) {
        case StateType.TYPE_DISPLAY_SIZE:
          this.refreshOrientation();
          break;
        default:
          break;
      }
    }
  };

  /**
   * 是否为折叠屏完全折叠or半展开态
   *
   * @returns true是，false不是
   */
  private isFoldedOrHalf(): boolean {
    let isFolded: boolean = false;
    try {
      const status = display.getFoldStatus();
      isFolded = display.isFoldable() && (status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED ||
        status === display.FoldStatus.FOLD_STATUS_FOLDED);
    } catch (error) {
      log.showError(TAG, 'isFoldedOrHalf -> try error:', error);
    }
    return isFolded;
  }

  private registerKeyboardState(): void {
    try {
      sensor.on(sensor.SensorId.HALL, (data: sensor.HallResponse) => {
        // bit2为1表示键盘在位
        this.isKeyboardOn = (data?.status >> 2 & 1) > 0;
        log.showInfo(TAG, `succeeded in invoking on. Hall status: ${this.isKeyboardOn}, this.isKeyboard: ${data?.status}`);
      }, { interval: SENSOR_INTERVAL });
    } catch (error) {
      log.showError(TAG, `Failed to invoke on. Code: ${error?.code}, message: ${error?.message}`);
    }
  }

  private getRealHeight(): Length {
    if (!DeviceHelper.isBigScreenMachine()) {
      return this.rotateHeight;
    }
    if (this.isOrientationLandscape) {
      return this.rotateHeight;
    }
    return (this.isFold || this.isKeyboardOn) ? '50%' : '100%';
  }

  private getRealWidth(): Length {
    if (!DeviceHelper.isBigScreenMachine()) {
      return this.rotateWidth;
    }
    if (this.isOrientationLandscape) {
      return this.isKeyboardOn ? '50%' : '100%';
    }
    return this.rotateWidth;
  }

  aboutToAppear() {
    const connectId = this.item?.connectId;
    log.showInfo(TAG, `${connectId} item aboutToAppear ${this.index} screenId:${this.screenId}`);

    // Add for AuthWidget rotate on 5.0, and removed on 6.0
    this.processUiExtNodeAngle();

    this.preProcessFromFoldDevice();

    // 处理手势
    if (this.isEnableBackGesture) {
      this.registerBackPressListener();
    }

    // 添加一个延迟关闭弹窗事件
    this.timeoutFlag = setTimeout(() => {
      this.onClose();
      log.showWarn(TAG, `${connectId} DialogAbility onReady timeout, onClose start ${this.timeoutFlag}`);
      SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
        this.item, SystemDialogState.CLOSE_TIMEOUT);
    }, DIALOG_CLEAR_TIMEOUT)
  }

  // Add for AuthWidget rotate on 5.0, and removed on 6.0
  private processUiExtNodeAngle(): void {
    try {
      this.displayHeight = display.getDefaultDisplaySync().height;
      this.displayWidth = display.getDefaultDisplaySync().width;
      this.rotateAngle = this.item?.want.parameters?.['ability.want.params.uiExtNodeAngle'] as string;
      switch (this.rotateAngle) {
        case (UiExtNodeAngle.TO_PORTRAIT):
          this.rotateHeight = this.displayWidth + 'px';
          this.rotateWidth = this.displayHeight + 'px';
          this.translateX = ResourceUtil.isRTL() ? this.displayHeight : this.displayWidth;
          this.translateY = (this.displayWidth - this.displayHeight) / 2;
          break;
        case (UiExtNodeAngle.TO_PORTRAIT_INVERTED):
          this.rotateHeight = this.displayWidth + 'px';
          this.rotateWidth = this.displayHeight + 'px';
          this.translateX = ResourceUtil.isRTL() ? (this.displayHeight - this.displayWidth) : 0;
          this.translateY = (this.displayWidth + this.displayHeight) / 2;
          break;
        case (UiExtNodeAngle.TO_INVERTED):
          this.rotateWidth = this.displayWidth + 'px';
          this.rotateHeight = this.displayHeight + 'px';
          this.rotateCenterX = '50%';
          this.rotateCenterY = '50%';
          this.translateX = 0;
          this.translateY = 0;
          break;
        default:
          this.rotateAngle = UiExtNodeAngle.DEFAULT;
      }
    } catch (error) {
      this.onClose();
      log.showError(TAG, `processUiExtNodeAngle error: ${error?.code}`);
    }
  }

  aboutToDisappear() {
    const connectId = this.item?.connectId;
    log.showInfo(TAG, `${connectId} item aboutToDisappear ${this.index} - ${this.timeoutFlag} screenId:${this.screenId}`);
    if (this.timeoutFlag !== 0) {
      clearTimeout(this.timeoutFlag);
    }
    if (this.isEnableBackGesture) {
      this.unregisterBackPressListener();
    }

    if (DeviceHelper.isBigScreenMachine()) {
      // 注销折叠监听
      try {
        display.off('foldStatusChange', this.onFoldStatusChangeListener);
        sensor.off(sensor.SensorId.HALL);
        baseStateMgr.unregisterStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onDisplaySizeChange);
      } catch (error) {
        log.showError(TAG, `unregister fold status change listener failed: ${error?.code}`);
      }
    }
  }

  build() {
    Row() {
      if (this.item) {
        UIExtensionComponent(this.item.want as Want)
          .defaultFocus(true)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            centerX: this.rotateCenterX,
            centerY: this.rotateCenterY,
            angle: this.rotateAngle
          })
          .translate({ x: this.translateX + 'px', y: this.translateY + 'px' })
          .width(this.getRealWidth())
          .height(this.getRealHeight())
          .backgroundColor(Color.Transparent)
          .onBlur(() => {
            this.dealOnBlur();
          })
          .onRelease(code => {
            const connectId = this.item?.connectId;
            log.showWarn(TAG, `${connectId} onRelease${code} start`);
            this.onClose();
            log.showInfo(TAG, `${connectId} onRelease${code} end`);
          })
          .onResult((data) => {
            const connectId = this.item?.connectId;
            log.showWarn(TAG, `${connectId} onResult UIExtension onResult ${data.code}`);
            this.onClose();
          })
          .onRemoteReady((proxy: UIExtensionProxy) => {
            const connectId = this.item?.connectId;
            this.mProxy = proxy;
            log.showWarn(TAG, `${connectId} onRemoteReady Success! ${this.timeoutFlag}`);
            if (this.timeoutFlag !== 0) {
              clearTimeout(this.timeoutFlag);
              log.showInfo(TAG, `${connectId} onRemoteReady clearTimeout! ${this.timeoutFlag}`);
            }
          })
          .onError(error => {
            const connectId = this.item?.connectId;
            log.showWarn(TAG, `${connectId} onError ${error?.message} start`);
            this.onClose();
            log.showWarn(TAG, `${connectId} onError ${error?.message} end`);
            SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
              this.item, SystemDialogState.ERROR);
          })
      }
    }
    .width('100%')
    .height('100%')
    .alignItems((this.isFold || this.isKeyboardOn) ? VerticalAlign.Top : VerticalAlign.Center)
    .backgroundColor(this.getBackgroundColor())
  }

  getBackgroundColor(): ResourceColor {
    if (DeviceHelper.isBigScreenMachine() && !this.item?.want?.parameters?.isSetPcBgColorTransparent) {
      return $r('sys.color.ohos_id_color_mask_thin');
    }
    return Color.Transparent;
  }

  onClose() {
    const connectId = this.item?.connectId;
    const sysDialogZOrder = this.item?.sysDialogZOrder;
    const screenId = this.screenId;
    const abilityName = this.item?.want.abilityName;
    log.showWarn(TAG, `${connectId} onClose start ${abilityName} screenId:${screenId}`);
    if (this.item) {
      SystemDialogController.getInstance().closeByConnectId(
        connectId as string,
        sysDialogZOrder as SysDialogZOrder,
        true,
        abilityName
      );
    }
    SystemDialogController.getInstance().requestDestroy();
    log.showWarn(TAG, `${connectId} onClose end ${abilityName}`);
  }

  dealOnBlur(): void {
    log.showInfo(TAG, 'dealOnBlur');
    if (!DeviceHelper.isPC()) {
      return;
    }
    let supportCloseOnBlur: boolean = this.item?.want?.parameters?.['supportCloseOnBlur'] as boolean;
    log.showInfo(TAG, `dealOnBlur, supportCloseOnBlur: ${supportCloseOnBlur}`);
    // 适配PC支持失焦自动关闭弹框场景
    if (supportCloseOnBlur) {
      this.onClose();
    }
  }
}

