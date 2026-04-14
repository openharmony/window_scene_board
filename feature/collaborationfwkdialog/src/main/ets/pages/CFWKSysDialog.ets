/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { sensor } from '@kit.SensorServiceKit';
import { ResourceUtil } from '../common/ResourceUtil';
import { CKWKSysDialogManager } from './CFWKSysDialogManager';
import display from '@ohos.display';
import {
  SysDialogZOrder,
  UiExtNodeAngle,
  GestureState,
  GestureConstant,
  RotateState,
  SysDialogParamsKey,
  RequestCommand,
} from '../common/Constants';
import SystemDialogController from '../controller/Controller';
import { DialogDataEvent, ISystemDialogData, IParameters } from '../common/DialogDataEvent';
import { SystemDialogEventUtil, SystemDialogState } from '../common/SysDialogEventUtil';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { BackPressPriority, baseStateMgr, IState, OnStateChangeListener, StateType, SysDialogType } from '@ohos/systemuiutils';
import { windowManager } from '@ohos/componentdrag';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'CFWKSysDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const DIALOG_CLEAR_TIMEOUT: number = 5000;
const SENSOR_INTERVAL: number = 100000000;

/**
 * 低层级系统弹框
 */
@Component
export struct CFWKSysDialogDefault {
  persistentId: number = 0;
  screenProp: SCBScreenProperty | null = null;

  aboutToAppear(): void {
    log.showInfo(`CFWKSysDialogDefault aboutToAppear`);
    this.processTransparentException(this.persistentId, 'CFWKSysDialogDefault');
  }

  aboutToDisappear(): void {
    this.screenProp = null;
    log.showInfo(`CFWKSysDialogDefault aboutToDisappear`);
  }

  // dialog需要距离底部80VP
  private processTransparentException = (persistentId: number, componentName: string): void => {
    // 零层透明异常处理
    let sCBSceneSessionManagertInstance: SCBSceneSessionManager | null = globalThis.SCBSceneSessionManagerInstance;
    let systemSceneSession = sCBSceneSessionManagertInstance?.getSystemSceneSessionWithId(persistentId);
    if (CommonUtils.isInvalid(systemSceneSession)) {
      log.showWarn(`${persistentId} ${componentName} session is invalid`);
    }
    systemSceneSession?.registerContextTransparentCallback(() => {
      log.showWarn(`${persistentId} ${componentName} is transparency!!`);
      systemSceneSession?.setVisibility(false);
    })
  }

  @Builder
  showDefaultDialog() {
    CFWKSysDialog({
      zorder: SysDialogZOrder.DEFAULT,
      persistentId: this.persistentId,
      viewTypeKey: SysDialogType.TYPE_DEFAULT
    })
  }

  build() {
    if (this.screenProp) {
      this.showDefaultDialog();
    }
  }
}

/**
 * 高层级系统弹框
 */
@Component
export struct CFWKSysDialogUpper {
  /**
   * 面板ID
   */
  persistentId: number = 0;
  /**
   * 屏幕属性
   */
  screenProp: SCBScreenProperty | null = null;


  aboutToAppear(): void {
    log.showInfo(`CFWKSysDialogUpper aboutToAppear`);
    this.processTransparentException(this.persistentId, 'CFWKSysDialogUpper');
  }

  aboutToDisappear(): void {
    this.screenProp = null;
    log.showInfo(`CFWKSysDialogDefault aboutToDisappear`);
  }

  // dialog需要距离底部80VP
  private processTransparentException(persistentId: number, componentName: string) {
    // 零层透明异常处理
    let sCBSceneSessionManagertInstance: SCBSceneSessionManager | null = globalThis.SCBSceneSessionManagerInstance;
    let systemSceneSession = sCBSceneSessionManagertInstance?.getSystemSceneSessionWithId(persistentId);
    if (CommonUtils.isInvalid(systemSceneSession)) {
      log.showWarn(`${persistentId} ${componentName} session is invalid`);
    }
    systemSceneSession?.registerContextTransparentCallback(() => {
      log.showWarn(`${persistentId} ${componentName} is transparency!!`);
      systemSceneSession?.setVisibility(false);
    })
  }

  @Builder
  showUpperDialog() {
    CFWKSysDialog({
      zorder: SysDialogZOrder.UPPER,
      persistentId: this.persistentId,
      viewTypeKey: SysDialogType.TYPE_UPPER
    })
  }

  build() {
    if (this.screenProp) {
      this.showUpperDialog();
    }
  }
}

@Component
struct CFWKSysDialog {
  /**
   * 面板ID
   */
  persistentId: number = 0;
  /**
   * 面板序号
   */
  zorder?: SysDialogZOrder = SysDialogZOrder.DEFAULT;
  /**
   * 面板类型
   */
  screenId: number = 0;

  private viewTypeKey: SysDialogType = SysDialogType.TYPE_DEFAULT;
  /**
   * 三方系统弹框数据集
   */
  @State list: Array<ISystemDialogData> = [];

  @StorageProp('cfwkSysDialogEvent') @Watch('onDialogDataEvent')
  event?: DialogDataEvent = SystemDialogController.getInstance().getSysDialogEvent();

  /**
   * 是否为轴事件:当前仅在由鼠标滚轮或者触控板双指滑动场景下触发的Pan手势中可以获取
   */
  private isAxisEvent: boolean = false;

  private cfwkSysDialogMgr?: CKWKSysDialogManager = new CKWKSysDialogManager(this.viewTypeKey, this.screenId);
  /**
   * 弹框数据刷新回调事件
   */
  private onDialogDataEvent() {
    log.showWarn(`onDialogDataEvent start`);
    if (!this.event || !this.event.item) {
      this.list = [];
      return;
    }
    let sysDialogZOrder = this.event.dialogZOrder;
    let list = this.event.dataList;
    let count = this.event.count;
    let flag = this.event.flag || 0;
    const bundleName = this.event.item.want.bundleName;

    if (sysDialogZOrder === this.zorder) {
      this.list = list;
      if (list.length) {
        // 先判断是否需要预加载，flag大于1则表示需要预加载
        log.showWarn(`flag: ${flag} bundleName:${bundleName} count: ${count}}`);
        const whitelist = [
          'com.ohos.superdevice'
        ];
        if (whitelist.includes(bundleName as string)) {
          // 预加载
          if (flag === RequestCommand.PRELOAD) {
            log.showInfo(`Step1 Preload`);
            this.cfwkSysDialogMgr?.requestPanelOuter2();
          }
          if (flag === RequestCommand.SHOW) {
            // 展示窗口
            log.showInfo(`Step2 Show`);
            this.processDialogData(this.event);
            this.cfwkSysDialogMgr?.getDialogState().getPanelController()?.show()
          }
          if (flag === RequestCommand.START_DIALOG) {
            log.showInfo(`show normal`);
            // 其他弹窗正常加载窗口
            this.cfwkSysDialogMgr?.requestPanelOuter();
            setTimeout((dialog: CFWKSysDialog) => {
              if (dialog.event && dialog.event.item && dialog.list.length) {
                dialog.processDialogData(dialog.event);
              }
            }, 200, this);
          }
        }
      } else {
        // when hide, the following registerUnfocusedCallback will be triggered
        this.cfwkSysDialogMgr?.releasePanelOuter();
      }
    }
  };

  /**
   * 根据业务传递参数处理不同的场景
   */
  private processDialogData(event: DialogDataEvent) {
    const zOrder = event.dialogZOrder;
    const list = event.dataList;
    const item = event.item as ISystemDialogData;
    const upperList = zOrder === SysDialogZOrder.UPPER ? list : event.upperList;
    const defaultList = zOrder === SysDialogZOrder.DEFAULT ? list : event.defaultList;
    log.showInfo(`processDialogData l:${list.length} d:${defaultList.length} u:${upperList.length} zOrder:${zOrder}`);
    this.setGyroRotationState([...defaultList, ...upperList]);
    this.setGestureState(defaultList, upperList);
    SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME, item, SystemDialogState.GESTURE);
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
    log.showInfo(`setGyroRotationState ${isEnableRotate}`);
    this.cfwkSysDialogMgr?.setEnableRotate(isEnableRotate);
  }

  /**
   * 设置手势状态
   */
  private setGestureState(defaultList: ISystemDialogData[] = [], upperList: ISystemDialogData[] = []) {
    // 获取所有弹窗中最上层的弹窗
    let lastDialog: ISystemDialogData | undefined = undefined;
    if (defaultList.length > 0) {
      lastDialog = defaultList?.[defaultList.length - 1];
    }
    // 设置最后一个弹窗的手势
    if (lastDialog) {
      const lastWantParameters = lastDialog?.want?.parameters as IParameters;
      const isEnableStatusBarGesture = lastWantParameters?.isEnableStatusBarGesture === GestureState.ENABLE;
      const isEnableBackGesture = lastWantParameters?.isEnableBackGesture === GestureState.ENABLE;
      log.showInfo(`setGestureState lastWantParameters gesture state: ${isEnableStatusBarGesture} ${isEnableBackGesture}`);
      this.cfwkSysDialogMgr?.setGestureState(isEnableStatusBarGesture, isEnableBackGesture);
    } else {
      log.showInfo(`setGestureState no lastDialog`);
      this.cfwkSysDialogMgr?.setGestureState(true, false);
    }
  }

  /**
   * 定制化桌面应用分享框的层级
   *
   * @param defaultList 所有弹框
   */
  aboutToAppear() {
    log.showInfo(`aboutToAppear zorder ${this.zorder} ${this.persistentId}`);
    // 系统弹框统一管理
    this.cfwkSysDialogMgr?.appear(this.persistentId);
    log.showInfo(`cfwk dialog Preload`);
    this.onDialogDataEvent();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear zorder ${this.zorder} ${this.persistentId}`);
    this.list = [];
    this.event = undefined;
    this.cfwkSysDialogMgr?.releasePanelOuter();
    this.cfwkSysDialogMgr?.disappear();
    this.cfwkSysDialogMgr = undefined;
  }

  private isFastUpSwiper(event: GestureEvent): boolean {
    const ret = Math.abs(event.offsetX) < Math.abs(event.offsetY) && event.velocityY < GestureConstant.SWIPE_SPEED;
    log.showInfo('isFastUpSwiper velocityY: %{public}d, ret: %{public}s', event.velocityY, ret);
    return ret;
  }

  private onActionStartEvent = (event: GestureEvent): void => {
    const abilityName = this.list?.map(o => o?.want?.abilityName)?.toString();
    // 轴事件(鼠标滚轮,触摸版本的双指滑动) 不同时为0, 手指触摸屏幕则都为0
    const axisHorizontal = event?.axisHorizontal;
    const axisVertical = event?.axisVertical;
    this.isAxisEvent = axisHorizontal !== 0 || axisVertical !== 0;
    log.showWarn(`onActionStartEvent ${abilityName} H:${axisHorizontal} V:${axisVertical}`);
  }

  private onActionEndEvent = (event: GestureEvent): void => {
    if (this.isAxisEvent) {
      // 轴事件情况下直接返回
      log.showWarn(`onActionEndEvent isAxisEvent ${this.isAxisEvent}`);
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
    log.showWarn(`onActionEndEvent isFromBottom ${isFromBottom}`);
    if (!isFromBottom) {
      return
    }
    // 是否快速滑动
    const isFastUpSwiper = this.isFastUpSwiper(event);
    // 偏移量
    const offsetY = Math.abs(event?.offsetY);
    // 是否关闭弹框
    const isNeedClose = offsetY > GestureConstant.PAN_DISTANCE || isFastUpSwiper;
    log.showWarn(`onActionEndEvent isNeedClose ${isNeedClose}`);
    if (isNeedClose) {
      SystemDialogController.getInstance().clearAll();
    }
    log.showInfo('onActionEndEvent (%{public}d, %{public}d), bottom: %{public}d offsetY: %{public}d',
      event.offsetX, event.offsetY, bottomHeight, offsetY);
  }

  build() {
    Stack() {
      ForEach(
        this.list,
        (item: ISystemDialogData, index?: number) => {
          Item({
            cfwkSysDialogMgr: this.cfwkSysDialogMgr,
            index,
            item,
            isEnableBackGesture: item?.want?.parameters?.isEnableBackGesture === GestureState.ENABLE,
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

@Component
struct Item {
  cfwkSysDialogMgr: CKWKSysDialogManager | null = null;

  index: number = 0;
  item: ISystemDialogData | null = null;

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
  private isEnableBackGesture: boolean = false;
  private isSetPcShowFullScreen: boolean = false;
  @State isFold: boolean = false;
  @State isKeyboardOn: boolean = false;
  @State isOrientationLandscape: boolean = false;

  /**
   * 超时任务Flag
   */
  timeoutFlag: number = 0;

  // 注册透传手势监听器
  private registerBackPressListener() {
    log.showInfo(`registerBackPressListener`);
    this.cfwkSysDialogMgr?.registerBackPressListener(this.onBackPressListener, BackPressPriority.PRIORITY_SHUTDOWN);
  }

  // 取消注册透传手势监听器
  private unregisterBackPressListener() {
    log.showInfo(`unregisterBackPressListener`);
    this.cfwkSysDialogMgr?.unregisterBackPressListener(this.onBackPressListener);
  }

  // 返回键回调
  private onBackPressListener = (type?: SysDialogType): boolean => {
    log.showInfo(`onBackPressListener start`);
    if (this.mProxy && this.isEnableBackGesture) {
      log.showInfo(`onBackPressListener send`);
      this.mProxy?.send({ isGestureBack: true, message: 'handle gesture back successfully' });
      log.showInfo(`onBackPressListener send done ${type}`);
      return false;
    }
    return true;
  }

  private preProcessFromFoldDevice(): void {
    // 显示前获取当前折叠状态
    this.isFold = this.isFoldedOrHalf(); // 注册折叠监听
    try {
      display.on('foldStatusChange', this.onFoldStatusChangeListener);
      this.registerKeyboardState();
      this.refreshOrientation();
      baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onDisplaySizeChange);
      log.showInfo(`refreshOrientation preProcessFromFoldDevice isOrientationLandscape: ${this.isOrientationLandscape}`);
    } catch (error) {
      log.showError(`register fold status change listener failed: ${error?.code}`);
    }
  }

  /**
   * 是否为折叠屏并且完全折叠or半展开态
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
      log.showError('isFoldedOrHalf -> try error:', error);
    }
    return isFolded;
  }

  private onFoldStatusChangeListener = (status: display.FoldStatus): void => {
    this.isFold = this.isFoldedOrHalf();
    log.showInfo(`fold status change to: ${status}`);
  }

  private registerKeyboardState(): void {
    try {
      sensor.on(sensor.SensorId.HALL, (data: sensor.HallResponse) => {
        // bit2为1表示键盘在位
        this.isKeyboardOn = (data?.status >> 2 & 1) > 0;
        log.showInfo(`succeeded in invoking on. Hall status: ${this.isKeyboardOn}, this.isKeyboard: ${data?.status}`);
      }, { interval: SENSOR_INTERVAL });
    } catch (error) {
      log.showError(`Failed to invoke on. Code: ${error?.code}, message: ${error?.message}`);
    }
  }

  private refreshOrientation(): void {
    try {
      const orientation: display.Orientation = display.getDefaultDisplaySync().orientation;
      if (orientation === display.Orientation.LANDSCAPE || orientation === display.Orientation.LANDSCAPE_INVERTED) {
        this.isOrientationLandscape = true;
        return;
      }
    } catch (err) {
      log.showError(`refreshOrientation failed. error: ${err?.code} ${err?.message}`);
    }
    this.isOrientationLandscape = false;
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

  private getRealHeight(): Length {
    if (this.isSetPcShowFullScreen) {
      return this.rotateHeight;
    }
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

  private getAlignItems(): VerticalAlign {
    if (this.isSetPcShowFullScreen) {
      return VerticalAlign.Center;
    }
    return (this.isFold || this.isKeyboardOn) ? VerticalAlign.Top : VerticalAlign.Center;
  }

  aboutToAppear() {
    const connectId = this.item?.connectId;
    const abilityName = this.item?.want.abilityName;
    log.showInfo(`${connectId} cfwkDialogItem ${abilityName} aboutToAppear ${this.index} - ${this.timeoutFlag}`);

    // Add for AuthWidget rotate on 5.0, and removed on 6.0
    this.processUiExtNodeAngle();

    if (DeviceHelper.isPC() && DeviceHelper.isBigScreenMachine()) {
      this.isSetPcShowFullScreen = this.item?.want?.parameters?.isSetPcShowFullScreen as boolean;
      this.preProcessFromFoldDevice();
    }

    // 处理手势
    if (this.isEnableBackGesture) {
      this.registerBackPressListener();
    }

    // 添加一个延迟关闭弹窗事件
    this.timeoutFlag = setTimeout(() => {
      this.onClose();
      log.showWarn(`${connectId} DialogAbility onReady timeout, onClose start ${this.timeoutFlag}`);
      SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
        this.item as ISystemDialogData, SystemDialogState.CLOSE_TIMEOUT);
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
    log.showInfo(`${connectId} cfwkDialogItem aboutToDisappear ${this.index} - ${this.timeoutFlag}`);
    if (this.timeoutFlag !== 0) {
      clearTimeout(this.timeoutFlag);
    }
    if (this.isEnableBackGesture) {
      this.unregisterBackPressListener();
    }
    if (DeviceHelper.isPC() && DeviceHelper.isBigScreenMachine()) {
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
        UIExtensionComponent(this.item.want)
          .defaultFocus(true)
          .rotate({
            x: 0, y: 0, z: 1,
            centerX: this.rotateCenterX, centerY: this.rotateCenterY,
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
            log.showWarn(`${connectId} onRelease${code} start`);
            this.onClose();
            log.showInfo(`${connectId} onRelease${code} end`);
          })
          .onResult((data) => {
            const connectId = this.item?.connectId;
            log.showWarn(`${connectId} onResult UIExtension onResult ${data.code}`);
            this.onClose();
          })
          .onRemoteReady((proxy: UIExtensionProxy) => {
            const connectId = this.item?.connectId;
            this.mProxy = proxy;
            log.showWarn(`${connectId} onRemoteReady Success! ${this.timeoutFlag}`);
            if (this.timeoutFlag !== 0) {
              clearTimeout(this.timeoutFlag);
              log.showInfo(`${connectId} onRemoteReady clearTimeout! ${this.timeoutFlag}`);
            }
          })
          .onError(error => {
            const connectId = this.item?.connectId;
            log.showWarn(`${connectId} onError ${error?.message} start`);
            this.onClose();
            log.showWarn(`${connectId} onError ${error?.message} end`);
            SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
              this.item as ISystemDialogData, SystemDialogState.ERROR);
          })
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(this.getAlignItems())
    .backgroundColor(Color.Transparent)
  }

  onClose() {
    const connectId = this.item?.connectId;
    const sysDialogZOrder = this.item?.sysDialogZOrder;
    const abilityName = this.item?.want.abilityName;
    log.showWarn(`${connectId} onClose start ${abilityName}`);
    if (this.item) {
      SystemDialogController.getInstance().closeByConnectId(
        connectId as string,
        sysDialogZOrder as SysDialogZOrder,
        true,
        abilityName
      );
    }
    SystemDialogController.getInstance().requestDestroy();
    log.showWarn(`${connectId} onClose end ${abilityName}`);
  }

  dealOnBlur(): void {
    const connectId = this.item?.connectId;
    const abilityName = this.item?.want.abilityName;
    log.showWarn(`${connectId} dealOnBlur start ${abilityName}`);
    if (!DeviceHelper.isPC()) {
      return;
    }
    let supportCloseOnBlur: boolean = this.item?.want?.parameters?.['supportCloseOnBlur'] as boolean;
    log.showInfo(`${connectId} dealOnBlur, supportCloseOnBlur: ${supportCloseOnBlur} ${abilityName}`);
    // 适配PC支持失焦自动关闭弹框场景
    if (supportCloseOnBlur) {
      this.onClose();
    }
  }
}