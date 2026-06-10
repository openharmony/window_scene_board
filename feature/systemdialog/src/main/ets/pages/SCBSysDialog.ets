/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import display from '@ohos.display';
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { DeviceHelper, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { BackPressPriority, OnBackPressListener, sysDialogMgr, SysDialogType } from '@ohos/systemuiutils';
import { DeviceModeEnum } from '@ohos/commonconstants';
import { windowManager } from '@ohos/componentdrag';
import {
  SysDialogZOrder,
  UiExtNodeAngle,
  GestureState,
  GestureConstant,
  RotateState,
  SysDialogParamsKey,
  SysDialogZIndex,
  CommonDialog,
  UnoccludeState,
  FocusState,
} from '../common/Constants';
import SystemDialogController from '../controller/Controller';
import { DialogDataEvent, IParameters, ISystemDialogData } from '../common/DialogDataEvent';
import { SystemDialogEventUtil, SystemDialogState } from '../common/SysDialogEventUtil';
import { PCSCBSysDialog } from './pc/PCSCBSysDialog';
import {
  LowerStatusDialogType,
  ShutdownCustomDialog
} from '@ohos/batterycomponent/src/main/ets/default/pages/ShutdownCustomDialog';
import { OuterShutdownCustomDialog } from '@ohos/batterycomponent/src/main/ets/default/pages/OuterShutdownCustomDialog';
import { shutdownDialogVm } from '@ohos/batterycomponent/src/main/ets/default/vm/ShutdownDialogVm';
import { ResourceUtil } from '../common/ResourceUtil';
import {
  ISysFloatingTipController,
  ScreenLockFloatingTipAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockFloatingTipAdapter';
import { screenLockSysFloatTipControl } from '@ohos/screenlockcommon/Index';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { PowerStatusMonitorAdapter, IPowerStatusMonitor
} from '@ohos/systemuicommon/src/main/ets/adapter/PowerStatusMonitorAdapter';
import { ScreenLockApi, screenLockInnerStateManager, ScreenLockStateManager,
  ScreenLockUnlockService,
  SystemSwitchUtils } from '@ohos/screenlockcommon';
import { PowerStatusMonitor } from '@ohos/screenlockcommon/Index';
import { ScreenLockAdapter } from '@ohos/systemuicommon';

ScreenLockFloatingTipAdapter.setController(screenLockSysFloatTipControl as ISysFloatingTipController);
ScreenLockFloatingTipAdapter.setLiveListTip(
  ScreenLockNotificationConst.NTF_OUT_LIVE_LIST_KEY_GUARD_TIP,
  ScreenLockNotificationConst.KG_NTF_CLICK_TIP,
);
PowerStatusMonitorAdapter.init(PowerStatusMonitor.getInstance() as IPowerStatusMonitor);
ScreenLockAdapter.setStateManager(ScreenLockStateManager.getInstance());
ScreenLockAdapter.setInnerStateManager(screenLockInnerStateManager);
ScreenLockAdapter.setScreenLockApi(ScreenLockApi);
ScreenLockAdapter.setSwitchUtils(SystemSwitchUtils);
ScreenLockAdapter.setUnlockService(ScreenLockUnlockService.getInstance());

const TAG = 'SCBSysDialog';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const DIALOG_CLEAR_TIMEOUT: number = 5000;
// dialog需要距离底部80VP
const outerHomeDialogYOffset = -80;
const processTransparentException = (persistentId: number, componentName: string): void => {
  // 零层透明异常处理
  let sCBSceneSessionManagertInstance: SCBSceneSessionManager | null = globalThis.SCBSceneSessionManagerInstance;
  let systemSceneSession = sCBSceneSessionManagertInstance?.getSystemSceneSessionWithId(persistentId);
  if (CommonUtils.isInvalid(systemSceneSession)) {
    log.showWarn(TAG, `${persistentId} ${componentName} session is invalid`);
  }
  systemSceneSession?.registerContextTransparentCallback(() => {
    log.showWarn(TAG, `${persistentId} ${componentName} is transparency!!`);
    systemSceneSession?.setVisibility(false);
  })
}

/**
 * 低层级系统弹框
 */
@Component
export struct SCBSysDialogDefault {
  persistentId: number = 0;
  screenProp: SCBScreenProperty | null = null;

  aboutToAppear(): void {
    log.showInfo(TAG, `SCBSysDialogDefault aboutToAppear`);
    processTransparentException(this.persistentId, 'SCBSysDialogDefault');
  }

  @Builder
  showDefaultDialog() {
    if (DeviceHelper.isPC()) {
      PCSCBSysDialog({
        zorder: SysDialogZOrder.DEFAULT,
        persistentId: this.persistentId,
        screenId: this.screenProp?.screenId,
        viewTypeKey: SysDialogType.TYPE_DEFAULT
      })
    } else {
      SCBSysDialog({
        zorder: SysDialogZOrder.DEFAULT,
        persistentId: this.persistentId,
        viewTypeKey: SysDialogType.TYPE_DEFAULT
      })
    }
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
export struct SCBSysDialogUpper {
  /**
   * 面板ID
   */
  persistentId: number = 0;
  /**
   * 屏幕属性
   */
  screenProp: SCBScreenProperty | null = null;
  @State dialogType: LowerStatusDialogType = LowerStatusDialogType.SHUTDOWN;
  // 是否开启应急模式
  @StorageProp('deviceModeState') @Watch('onChangeDataEmitter') deviceModeState: DeviceModeEnum =
    DeviceModeEnum.BASE_MODE;

  // 触发应急模式关闭低电量弹窗
  onChangeDataEmitter(): void {
    log.showInfo(TAG, `onChangeDataEmitter ${this.deviceModeState}`);
    const isEmergencyModeState = this.deviceModeState === DeviceModeEnum.EMERGENCY_MODE;
    shutdownDialogVm.setEmergencyModeState(isEmergencyModeState);
    if (isEmergencyModeState) {
      this.shutdownDialog?.close();
      this.outerHomeShutdownDialog?.close();
      shutdownDialogVm.onDialogCancel();
    }
  };

  /**
   * 低电量关机提醒弹框，借助高层级弹框面板，PC不涉及
   */
  private shutdownDialog?: CustomDialogController = DeviceHelper.isPC() ? undefined : new CustomDialogController({
    builder: ShutdownCustomDialog({ dialogType: this.dialogType }),
    alignment: DialogAlignment.Center,
    autoCancel: true,
    backgroundColor: Color.Transparent,
    maskColor: $r('sys.color.ohos_id_color_mask_thin'),
    cancel: () => {
      log.showInfo(TAG, 'dialog auto cancel');
      shutdownDialogVm.onDialogCancel();
    }
  });
  private outerHomeShutdownDialog?: CustomDialogController =
    DeviceHelper.isPC() ? undefined : new CustomDialogController({
      builder: OuterShutdownCustomDialog({
        dialogType: this.dialogType
      }),
      alignment: DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: outerHomeDialogYOffset
      },
      autoCancel: true,
      backgroundColor: Color.Transparent,
      maskColor: $r('sys.color.ohos_id_color_mask_thin'),
      cancel: () => {
        log.showInfo(TAG, 'dialog auto cancel');
        shutdownDialogVm.onDialogCancel();
      },
      customStyle: true,
      cornerRadius: $r('sys.float.ohos_id_corner_radius_tips_instant_tip'),
    });

  aboutToAppear(): void {
    log.showInfo(TAG, `SCBSysDialogUpper aboutToAppear`);
    shutdownDialogVm.setShutdownDialog(this.shutdownDialog);
    shutdownDialogVm.getLowerStatusDialogType((type: LowerStatusDialogType) => {
      this.dialogType = type;
    })
    processTransparentException(this.persistentId, 'SCBSysDialogUpper');
  }

  @Builder
  showUpperDialog() {
    if (DeviceHelper.isPC()) {
      PCSCBSysDialog({
        zorder: SysDialogZOrder.UPPER,
        persistentId: this.persistentId,
        screenId: this.screenProp?.screenId,
        viewTypeKey: SysDialogType.TYPE_UPPER
      })
    } else {
      SCBSysDialog({
        zorder: SysDialogZOrder.UPPER,
        persistentId: this.persistentId,
        viewTypeKey: SysDialogType.TYPE_UPPER
      })
    }
  }

  build() {
    if (this.screenProp) {
      this.showUpperDialog();
    }
  }
}

@Component
struct SCBSysDialog {
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
  private viewTypeKey: SysDialogType = SysDialogType.TYPE_DEFAULT;
  /**
   * 三方系统弹框数据集
   */
  @State list: Array<ISystemDialogData> = [];
  /**
   * 事件管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 是否为轴事件:当前仅在由鼠标滚轮或者触控板双指滑动场景下触发的Pan手势中可以获取
   */
  private isAxisEvent: boolean = false;
  /**
   * 是否主动聚焦到UEC组件
   */
  private isRequestFocusUEC: boolean = false;

  /**
   * 弹框数据刷新回调事件
   */
  private onDialogDataEvent = (event: DialogDataEvent) => {
    let sysDialogZOrder = event.dialogZOrder;
    let list = event.dataList;

    if (sysDialogZOrder === this.zorder) {
      this.processDialogData(event);
      this.list = list;
      log.showWarn(TAG, `sysDialogZOrder:${this.zorder} list.length:${list.length} ` +
        `${JSON.stringify(this.list?.map(o => o?.id))}`);
      if (list.length) {
        sysDialogMgr.requestPanelOuter(this.viewTypeKey);
      } else {
        // when hide, the following registerUnfocusedCallback will be triggered
        sysDialogMgr.releasePanelOuter(this.viewTypeKey);
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
    log.showInfo(TAG, `processDialogData l:${list.length} d:${defaultList.length} u:${upperList.length}` +
      `zOrder:${zOrder}`);
    this.setGyroRotationState([...defaultList, ...upperList]);
    this.setGestureState(defaultList, upperList);
    this.setUnoccludeState(upperList);
    this.setFocusState(event);
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
    log.showInfo(TAG, `setGyroRotationState ${isEnableRotate}`);
    sysDialogMgr.setEnableRotate(isEnableRotate);
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
      this.setDialogZIndexForShare(defaultList);
    }

    // 设置最后一个弹窗的手势
    if (lastDialog) {
      const lastWantParameters = lastDialog?.want?.parameters as IParameters;
      const isEnableStatusBarGesture = lastWantParameters?.isEnableStatusBarGesture === GestureState.ENABLE;
      const isEnableBackGesture = lastWantParameters?.isEnableBackGesture === GestureState.ENABLE;
      log.showInfo(TAG, `setGestureState lastWantParam state: ${isEnableStatusBarGesture} ${isEnableBackGesture}`);
      sysDialogMgr.setGestureState(this.viewTypeKey, isEnableStatusBarGesture, isEnableBackGesture);
    } else {
      log.showInfo(TAG, `setGestureState no lastDialog`);
      sysDialogMgr.setGestureState(this.viewTypeKey, true, false);
    }
  }

  /**
   * 设置弹窗获焦模式
   */
  private setFocusState(event: DialogDataEvent): void {
    const dataListLen = event.dataList.length;
    const isAdd: boolean = dataListLen > this.list.length;
    const focusState = event.item?.want?.parameters?.focusState ?? FocusState.DEFAULT;

    // 主动聚焦到UEC组件: 仅在弹窗页面第一次显示时主动获取一次焦点
    if (isAdd && focusState === FocusState.ENABLE) {
      this.isRequestFocusUEC = true;
    } else {
      this.isRequestFocusUEC = false;
    }
    log.showInfo(TAG, `setFocusState focusState: ${focusState}, isRequestFocusUEC: ${this.isRequestFocusUEC}`);

    // 主动聚焦到0层窗口
    if (isAdd && focusState !== FocusState.DISABLE) {
      this.setSceneFocusable(true, true);
      return;
    }

    // 不获焦模式: 设置窗口不获取焦点，必须满足当所有弹窗页面都设置为不获取焦点时才生效
    const isAllUnFocusable: boolean = event.dataList?.every((item: ISystemDialogData) => {
      return item?.want?.parameters?.focusState === FocusState.DISABLE;
    });
    log.showInfo(TAG, `setFocusState isAllUnFocusable: ${isAllUnFocusable}`);
    if (isAllUnFocusable && dataListLen > 0) {
      this.setSceneFocusable(false);
      return;
    }

    // 弹窗全部关闭后，还原窗口可获焦状态
    if (!dataListLen) {
      this.setSceneFocusable(true, false);
    }
  }

  /**
   * 设置系统弹窗所在窗口的获焦模式
   * @param isFocusable: 窗口是否获焦
   * @param isRequestFocus: 是否主动聚焦到窗口上
   */
  private setSceneFocusable(isFocusable: boolean, isRequestFocus: boolean = false): void {
    try {
      log.showInfo(TAG, `setSceneFocusable start, isFocusable: ${isFocusable}, isRequestFocus: ${isRequestFocus}`);
      const sCBSceneSessionManagerInstance: SCBSceneSessionManager = globalThis.SCBSceneSessionManagerInstance;
      const systemSceneSession = sCBSceneSessionManagerInstance.getSystemSceneSessionWithId(this.persistentId);
      systemSceneSession?.setFocusable(isFocusable); // 设置窗口是否可获焦
      if (isFocusable && isRequestFocus) { // 主动聚焦到窗口
        sCBSceneSessionManagerInstance.requestFocus(this.persistentId, true);
      }
      log.showInfo(TAG, 'setSceneFocusable success');
    } catch (err) {
      log.showError(TAG, `setSceneFocusable failed, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /**
   * 定制化桌面应用分享框的层级
   *
   * @param defaultList 所有弹框
   */
  private setDialogZIndexForShare(defaultList: ISystemDialogData[]): void {
    if (defaultList.length === 1 && defaultList[0]?.want?.bundleName === CommonDialog.INSTANTSHARE_BUNDLE_NAME) {
      sysDialogMgr.setZIndex(SysDialogZIndex.INSTANTSHARE);
    } else {
      sysDialogMgr.setZIndex(SysDialogZIndex.DEFAULT);
    }
  }

  private setUnoccludeState(list: ISystemDialogData[] = []) {
    const sysDialogController = SystemDialogController.getInstance();
    const data = sysDialogController.filterListByKey(list, SysDialogParamsKey.isPageCoexistence, UnoccludeState.ENABLE);
    const isEnableUnocclude = data?.length ? true : false;
    log.showInfo(TAG, `setUnoccludeState ${isEnableUnocclude}`);
    sysDialogMgr.setUnoccludeState(isEnableUnocclude);
  }

  aboutToAppear() {
    log.showInfo(TAG, `aboutToAppear zorder ${this.zorder} ${this.persistentId}`);
    SystemDialogController.getInstance().setSysDialogStatus(true);
    // 系统弹框统一管理
    sysDialogMgr.appear(this.viewTypeKey, this.persistentId);

    // 弹框数据刷新事件
    this.eventMgr.on(DialogDataEvent, this.onDialogDataEvent);

    processTransparentException(this.persistentId, 'SCBSysDialog');
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear zorder ${this.zorder} ${this.persistentId}`);
    SystemDialogController.getInstance().setSysDialogStatus(false);
    this.eventMgr.offAll();
    sysDialogMgr.disappear(this.viewTypeKey);
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
    const windowHeight = windowManager.getWindowHeight() as number;
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

  private getItemKey(item: ISystemDialogData): string {
    return `${item.id}-${item?.want?.abilityName}-${item.timestamp}`;
  }

  build() {
    Stack() {
      ForEach(
        this.list,
        (item: ISystemDialogData, index?: number) => {
          Item({
            index,
            item,
            isEnableBackGesture: (item?.want?.parameters as IParameters)?.isEnableBackGesture === GestureState.ENABLE,
            viewTypeKey: this.viewTypeKey,
            isRequestFocusUEC: this.isRequestFocusUEC,
            itemKey: this.getItemKey(item),
          })
        },
        (item: ISystemDialogData, index) => this.getItemKey(item)
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
  private viewTypeKey: SysDialogType = SysDialogType.TYPE_DEFAULT;
  private isRequestFocusUEC: boolean = false;
  private itemKey: string = '';
  /**
   * 超时任务Flag
   */
  timeoutFlag: number = 0;

  // 注册透传手势监听器
  private registerBackPressListener() {
    log.showInfo(TAG, `registerBackPressListener`);
    sysDialogMgr.registerBackPressListener(this.viewTypeKey, this.onBackPressListener as OnBackPressListener,
      BackPressPriority.PRIORITY_SHUTDOWN);
  }

  // 取消注册透传手势监听器
  private unregisterBackPressListener() {
    log.showInfo(TAG, `unregisterBackPressListener`);
    sysDialogMgr.unregisterBackPressListener(this.viewTypeKey, this.onBackPressListener as OnBackPressListener);
  }

  // 返回键回调
  private onBackPressListener = (type: SysDialogType): boolean => {
    log.showInfo(TAG, `onBackPressListener start`);
    if (this.mProxy && this.isEnableBackGesture) {
      log.showInfo(TAG, `onBackPressListener send`);
      this.mProxy?.send({ isGestureBack: true, message: 'handle gesture back successfully' });
      log.showInfo(TAG, `onBackPressListener send done ${type}`);
      return false;
    }
    return true;
  }

  aboutToAppear() {
    const connectId = this.item?.connectId;
    const abilityName = this.item?.want.abilityName;
    log.showInfo(TAG, `${connectId} item ${abilityName} aboutToAppear ${this.index} - ${this.timeoutFlag}`);

    // Add for AuthWidget rotate on 5.0, and removed on 6.0
    this.processUiExtNodeAngle();

    // 处理手势
    if (this.isEnableBackGesture) {
      this.registerBackPressListener();
    }

    // 添加一个延迟关闭弹窗事件
    this.timeoutFlag = setTimeout(() => {
      this.onClose();
      log.showWarn(TAG, `${connectId} DialogAbility onReady timeout, onClose start ${this.timeoutFlag}`);
      SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
        this.item as ISystemDialogData, SystemDialogState.CLOSE_TIMEOUT);
    }, DIALOG_CLEAR_TIMEOUT);
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
    log.showInfo(TAG, `${connectId} item aboutToDisappear ${this.index} - ${this.timeoutFlag}`);
    if (this.timeoutFlag !== 0) {
      clearTimeout(this.timeoutFlag);
    }
    if (this.item?.want?.bundleName === CommonDialog.INSTANTSHARE_BUNDLE_NAME &&
      this.item?.sysDialogZOrder === SysDialogZOrder.DEFAULT) {
      sysDialogMgr.setZIndex(SysDialogZIndex.DEFAULT);
    }
    if (this.isEnableBackGesture) {
      this.unregisterBackPressListener();
    }
  }

  build() {
    Row() {
      if (this.item) {
        UIExtensionComponent(this.item.want as Want)
          .id(this.itemKey)
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
          .width(this.rotateWidth)
          .height(this.rotateHeight)
          .backgroundColor('#00000000')
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
            if (this.isRequestFocusUEC) {
              this.requestFocusUEC(this.itemKey);
            }
          })
          .onError(error => {
            const connectId = this.item?.connectId;
            log.showWarn(TAG, `${connectId} onError ${error?.message} start`);
            this.onClose();
            log.showWarn(TAG, `${connectId} onError ${error?.message} end`);
            SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
              this.item as ISystemDialogData, SystemDialogState.ERROR);
          })
      }
    }
    .width('100%')
    .height('100%')
  }

  onClose() {
    const connectId = this.item?.connectId;
    const sysDialogZOrder = this.item?.sysDialogZOrder;
    const abilityName = this.item?.want.abilityName;
    log.showWarn(TAG, `${connectId} onClose start ${abilityName}`);
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
    const connectId = this.item?.connectId;
    const abilityName = this.item?.want.abilityName;
    log.showWarn(TAG, `${connectId} dealOnBlur start ${abilityName}`);
    if (!DeviceHelper.isPC()) {
      return;
    }
    let supportCloseOnBlur: boolean = this.item?.want?.parameters?.['supportCloseOnBlur'] as boolean;
    log.showInfo(TAG, `${connectId} dealOnBlur, supportCloseOnBlur: ${supportCloseOnBlur} ${abilityName}`);
    // 适配PC支持失焦自动关闭弹框场景
    if (supportCloseOnBlur) {
      this.onClose();
    }
  }

  /**
   * 请求主动聚焦到UEC组件
   */
  private requestFocusUEC(focusId: string): void {
    try {
      log.showInfo(TAG, `requestFocusUEC start focusId: ${focusId}`);
      this.getUIContext().getFocusController().requestFocus(focusId);
      log.showInfo(TAG, 'requestFocusUEC success');
    } catch (err) {
      log.showError(TAG, `requestFocusUEC failed, code: ${err?.code}, message: ${err?.message}`);
    }
  }
}
