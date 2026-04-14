/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { CommonUtils, DomainName, LogDomain, LogHelper, ThreadUtil, TraceUtil } from '@ohos/basicutils';
import { DeviceHelper, EventManager, EvtBus, PluginSlot } from '@ohos/frameworkwrapper';
import { StatusBarTint } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarTint';
import lazy { StatusBarView } from '@ohos/statusbarcomponent/src/main/ets/view/StatusBarView';
import { statusBarVMV2 } from '@ohos/statusbarcomponent/src/main/ets/viewmodel/StatusBarVMV2';
import { DropdownVm, EnvVm,
  IStatusBarVmInjector, SystemUIView } from '@ohos/systemuicommon/newIndex';
import {
  SceneSessionAdapter,
  ScreenLockAdapter,
  StatusBarStyleChangeEvent,
  StatusBarType,
  statusBarMaskManager,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { StatusBarVmInjectorFactory } from '@ohos/statusbarcomponent/src/main/ets/StatusBarVmInjectorFactory';
import { FrameCallback } from '@kit.ArkUI';
import { ScreenLockVm } from '../viewmodel/ScreenLockVm';
import { StatusBarManager, IStatusBarManager } from '@ohos/systemuicommon/src/main/ets/statusbar/manager/StatusBarManager';
import { DropdownViewControllerAdapter } from '@ohos/systemuicommon';
import { sharedData } from '@ohos/systemuicommon/Index';

// instrument ignore file

const TAG = 'StatusBarBridgeView'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
class StatusBarColorChangeFrameCallback extends FrameCallback {
  private callback: Callback<void>;

  constructor(callback: Callback<void>) {
    super()
    this.callback = callback;
  }

  onFrame(frameTimeNanos: number) {
    if (this.callback) {
      log.showInfo(`FrameCallback do`);
      this.callback();
    }
  }
}

@Component
export struct StatusBarBridgeView {
  /*
    排除显示槽位列表
   */
  @Provide excludeSlotList: string[] = [];
  @Provide statusBarType: number = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
  /**
   * 状态栏内容颜色
   */
  @Provide contentColor: string = StatusBarTint.CONTENT_COLOR_WHITE;

  /**
   * 横竖屏状态
   */
  @Provide orientation: number = 0;
  /**
   * 状态栏左侧边距
   */
  @Provide statusBarPaddingLeft: string = '';
  /**
   * 状态栏右侧边距
   */
  @Provide statusBarPaddingRight: string = '';
  /**
   * 状态栏顶部边距
   */
  @Provide statusBarPaddingTop: string = '';
  /**
   * 状态栏左侧容器的右边界，通知图标使用变量计算展示图标的数量。无孔时根据此计算
   */
  @Provide statusBarGroupRight: number = 0;

  @Prop @Watch('refreshRenderGroupFlag') isVisible: Boolean = true;

  @Prop statusBarComponentOpacity: number = 1;

  @Prop isEnableMouseTypeStyle: boolean = false;

  /**
   * 触摸事件处理
   *
   * @param event 事件
   */
  private onTouchEvent:(event: TouchEvent) => void = (event: TouchEvent): void => {};

  /**
   * 手势事件处理
   *
   * @param event 事件
   */
  private onActionStartGestureEvent: (event: GestureEvent) => void = (event: GestureEvent): void => {};

  /**
   * 手势事件处理
   *
   * @param event 事件
   */
  private onActionUpdateGestureEvent: (event: GestureEvent) => void = (event: GestureEvent): void => {};


  private onSwipeGestureActionEvent: (event: GestureEvent) => void = (event: GestureEvent): void => {};

  /**
   * click事件处理
   */
  private onClickEvent: (event: ClickEvent) => void = (event: ClickEvent): void => {};

  @State isRenderGroupEnable: boolean = true;

  @StorageLink('isScreenProperty') @Watch('refreshRenderGroupFlag') isScreenProperty: boolean = false;

  @StorageLink('isMarqueeRunning') @Watch('refreshRenderGroupFlag') isMarqueeRunning: boolean = false;

  @State @Watch('onScreenLockVmChange') screenLockVm: ScreenLockVm = ScreenLockVm.instance;

  @StorageLink('canEnableStatusBarComponentRenderGroup') @Watch('refreshRenderGroupFlag')
  canEnableStatusBarComponentRenderGroup: boolean = true;

  @State @Watch('refreshRenderGroupFlag') isDropDownTypeLauncher: boolean = false;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear(): void {
    log.showInfo(`StatusBarBridgeView aboutToAppear start.`);
    statusBarVMV2.init(ScreenLockAdapter.getLock()?
    StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, this);

    this.refreshRenderGroupFlag();
    this.eventMgr.on(StatusBarStyleChangeEvent, this.onStatusBarStyleChangeEvent);
    log.showInfo(`StatusBarBridgeView aboutToAppear end.`);
  }

  aboutToDisappear(): void {
    log.showInfo(`StatusBarBridgeView aboutToDisappear start.`);
    statusBarVMV2.unInit();
    this.eventMgr.offAll()
    log.showInfo(`StatusBarBridgeView aboutToDisappear end.`);
  }

  build() {
    StatusBarViewV2({ isEnableMouseTypeStyle: this.isEnableMouseTypeStyle })
      .visibility(this.isVisible ? Visibility.Visible : Visibility.Hidden)
      .opacity(this.statusBarComponentOpacity)
      .hitTestBehavior(HitTestMode.Default)
      .position({x: 0})
      .id(TAG)
      .accessibilityLevel('no')
      .onTouch(this.onTouchEvent)
      .onClick(this.onClickEvent)
        // 单指竖直方向滑动时触发该事件
      .gesture(
        GestureGroup(GestureMode.Parallel,
          PanGesture({ direction: PanDirection.Vertical, distance: 5 })
            .onActionStart(this.onActionStartGestureEvent)
            .onActionUpdate(this.onActionUpdateGestureEvent),
          SwipeGesture({ direction: SwipeDirection.Vertical })
            .onAction(this.onSwipeGestureActionEvent)
        )
      );
  }

  onPluginContentColorChange(contentColor: string): void {
    log.showWarn(`onPluginContentColorChange ${contentColor}`);
    // 在宏任务更新contentColor，避免arkUI动效执行过程中改变下列变量，导致异常动效
    this.getUIContext().postFrameCallback(new StatusBarColorChangeFrameCallback(()=>{
      this.contentColor = contentColor;
      StatusBarVmInjectorFactory.get().getStatusBarIconListVm().contentColor = contentColor;
      EnvVm.instance.statusBarColor = this.contentColor;
    }));
  }

  setStatusBarType(statusBarType: number, isDropDown: boolean): void {
    log.showInfo(`change bar statusBarType: from ${this.statusBarType} to ${statusBarType}`);
    if (this.isDropDownTypeLauncher === isDropDown && this.statusBarType === statusBarType) {
      // 状态未更改
      return;
    }
    if (statusBarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN &&
      !sharedData.isDropDownShow) {
      statusBarMaskManager.setStatusBarMaskState(false);
      return;
    }

    if (this.statusBarType !== statusBarType) {
      if (statusBarType !== StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
        SceneSessionAdapter.updateSystemBarProperty();
      }
      log.showInfo(`change bar statusBarType: from ${this.statusBarType} to ${statusBarType}`)
      // 纯净显示下，下拉状态栏时 部分特定图标需要临时隐藏，避免布局变化导致的图标闪烁
      if (StatusBarVmInjectorFactory.get().getStatusBarSettingVm().isPureShow &&
        statusBarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
        StatusBarVmInjectorFactory.get().getStatusBarLayoutVm().hideIconForWhile();
      }
      // 更新状态栏类型与图标
      this.statusBarType = statusBarType;
      this.excludeSlotList =
        StatusBarVmInjectorFactory.get().getStatusBarIconListVm().getExcludeSlotList(this.statusBarType) ?? [];
      StatusBarVmInjectorFactory.get().getStatusBarIconListVm().statusBarType = statusBarType;
      DropdownVm.instance.updateStatusBarType(this.statusBarType);
      EnvVm.instance.statusBarType = statusBarType;
      TraceUtil.traceOnce(DomainName.SYS_UI, `setStatusBarType_${statusBarType}`);
    }
    this.isDropDownTypeLauncher = isDropDown;
  }

  private refreshRenderGroupFlag() {
    const currentIsRenderGroupEnable: boolean = this.getRenderGroup();
    if (this.isRenderGroupEnable === currentIsRenderGroupEnable) {
      return;
    }
    this.isRenderGroupEnable = currentIsRenderGroupEnable;
    StatusBarVmInjectorFactory.get().getStatusBarIconListVm().isRenderGroupEnable = currentIsRenderGroupEnable;
  }

  private getRenderGroup(): boolean {
    if (this.isScreenProperty || this.isMarqueeRunning) {
      return false;
    }

    if (this.isDropDownTypeLauncher || !(this.isVisible?.valueOf() ?? true)) {
      return false;
    }

    return this.canEnableStatusBarComponentRenderGroup;
  }

  /**
   * 获取状态栏类型
   * ComponentCallback复写
   *
   * @return 状态栏类型
   */
  getStatusBarType(): number {
    return this.statusBarType;
  }

  private onStatusBarStyleChangeEvent = (event: StatusBarStyleChangeEvent): void => {
    this.statusBarPaddingLeft = event.statusBarPaddingLeft;
    this.statusBarPaddingRight = event.statusBarPaddingRight;
    this.statusBarPaddingTop = event.statusBarPaddingTop;
  }

  private onScreenLockVmChange() {
    log.showInfo(`onScreenLockVmChange isPwdVisible ${this.screenLockVm.isPwdVisible}.`)
    this.onPwdVisibleChanged(this.screenLockVm.isPwdVisible);
  }

  private onPwdVisibleChanged(isPwdVisible: boolean) {
    log.showInfo(`onPwdVisibleChangedv2 to isPwdVisible: ${isPwdVisible}`);
    if (isPwdVisible) {
      statusBarVMV2.setStatusBarType(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
    }
  }
}

@ComponentV2
export struct StatusBarViewV2 {
  @Provider() statusBarVmInjector: IStatusBarVmInjector = StatusBarVmInjectorFactory.get();
  @Param isEnableMouseTypeStyle: boolean = false;

  build() {
    Stack() {
      if (ThreadUtil.isMainThread) {
        SystemUIView()
      }
      StatusBarView({ isEnableMouseTypeStyle: this.isEnableMouseTypeStyle })
    }
    .id('StatusBarViewV2')
  }
}