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

import { NotificationEntry } from '../../model/NotificationEntry';
import { NtfSingleItemVM } from '../../vm/NtfSingleItemVM';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { CommonUtils, LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { GlobalContext, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import {
  baseStateMgr,
  ImmersiveBaseState,
  StateType,
  LiveUseScene,
  BannerDeformState,
  LiveViewData,
} from '@ohos/systemuicommon';
import { PhoneNtfHeadsUpVm } from '../../vm/phone/PhoneNtfHeadsUpVM';
import { NtfHeadsUpVM } from '../../vm/NtfHeadsUpVM';
import { AnimatorResult } from '@ohos.animator';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { NotificationConfig } from '../../common/NotificationConfig';
import { BannerFloatingController } from '../../controller/BannerFloatingController';
import { RootCard } from '@ohos/systemuicommon/Index';
import { NotificationContentInTint } from './NotificationContentInTint';
import { NotificationContent } from './NotificationContent';
import { NtfTimeVM } from '../../vm/NtfTimeVM';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { curves } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/utils/RTLUtil';
import { ChildFunctionWrapper } from '../../common/NotificationUtils';


const TAG = 'NotificationHeadsUp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * 向上滑动超过距离收起窗口
 */
const UP_MOVE_DISTANCE = -20;
const HIDE_SCALE = 0.6;
const TRANSITION_DURATION = 250;
const CONTENT_MARGIN_TOP = 12;
const CONTENT_MARGIN_BOTTOM = 8;
const DEFAULT_BORDER_SIZE = 2; // 双描边需空出2vp

// 被新通知挤掉时的动效
const OUT_BY_OTHER_TRANSITION: TransitionEffect = TransitionEffect.OPACITY
  .animation({ duration: TRANSITION_DURATION, curve: curves.interpolatingSpring(0, 1, 300, 29) })
  .combine(TransitionEffect.scale({ x: HIDE_SCALE, y: HIDE_SCALE }))



/**
 * 横幅通知组件
 *
 * @since 2024-03-25
 */
@Component
export struct NotificationHeadsUpPc {
  /**
   * 圆角
   */
  @Prop radius: number | null = null;
  /**
   * 通知数据
   */
  @Provide ntfEntry?: NotificationEntry = undefined;

  /**
   * 是否为横幅通知
   */
  private isHeadsUp: boolean = false;
  /**
   * 是否禁用手势
   */
  @Prop isGestureDisable: boolean = false;
  /**
   * 记录是否window模式，被控制中心面板挡住
   */
  @Prop isBlocked: boolean = false;
  /**
   * 通知列表类型
   */
  @Consume notificationType: number;

  @Consume colorModeVM: NtfColorModeVM;
  /**
   * 窗口是否可见
   */
  @Consume @Watch('onWindowShowChange') isNtfWindowShow: boolean;
  /**
   * 通知条目横向平移距离
   */
  @State itemTranX: number = 0;
  /**
   * 按钮裁剪区域横向平移动画
   */
  private clipTranslateAnimator: AnimatorResult | undefined = undefined;
  /**
   * 通知条目横向平移动画
   */
  @State itemTranAnim: AnimateParam | null = null;
  /**
   * 通知条目正在被删除
   */
  @State itemIsDeleting: boolean = false;
  @State itemClickScale: number = 1;
  private touchStartX: number = 0;
  private touchStartY: number = 0;
  /**
   * 条目内容区域
   */
  private itemContentArea?: Area;
  /**
   * 条目VM
   */
  private itemVm: NtfSingleItemVM = new NtfSingleItemVM();
  /**
   * 横滑控制
   */
  private swipeController: NtfItemSwipeController = new NtfItemSwipeController();
  /**
   * close按钮VM
   */
  @Consume private closeVM?: NtfCloseVM;

  @State blurRadius: number = 0;
  /**
   * 是否正在执行消失行为，连续通知场景为true
   */
  @Prop @Watch('onHidingHeadsUp') isHidingHeadsUp: boolean = false;

  isBannerHeadsUpContent: boolean = false;
  /**
   * 横幅VM
   */
  private headsUpVM?: NtfHeadsUpVM;

  persistentId: number = 0;
  /**
   * 横竖屏转换
   */
  @StorageLink('isLandscape') isLandscape: boolean = false;

  private bgColor: ResourceColor = $r('app.color.ntf_brightness_bg_color')

  @Link itemScaleX: number;
  @Link itemScaleY: number;

  @State bannerHeight: number = 0;

  /**
   * 通知阴影效果
   */
  private shadowStyle?: ShadowOptions | ShadowStyle | undefined;

  /**
   * 形变相关参数
   */
  @Prop @Watch('onDeformChanged') bannerDeformState: BannerDeformState = new BannerDeformState();

  @Prop isInitParam: boolean = false;

  private bannerFloatingController: BannerFloatingController | undefined = undefined;

  /**
   * 沉浸式状态
   */
  @State immersiveState: ImmersiveBaseState = baseStateMgr.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;

  @State isDropBarVisible: boolean = false;

  @State initHeight: number = 0;

  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;

  /**
   * 横幅通知展开状态
   */
  @State isExpand: boolean = false;
  onContentAreaChange?: (newValue: Area, ntfEntry: NotificationEntry) => void = undefined;
  @Require private innerMargin: number = 0;
  @State myOutTransitionEffect: TransitionEffect = OUT_BY_OTHER_TRANSITION;
  private checkWrapper: ChildFunctionWrapper = new ChildFunctionWrapper();

  // 通知自然退出时的动效
  outNormalTransition: TransitionEffect = TransitionEffect
  .move(TransitionEdge.END)
  .animation({ duration: TRANSITION_DURATION, curve: curves.interpolatingSpring(0, 1, 300, 29) })
  .combine(TransitionEffect.scale({ x: HIDE_SCALE, y: HIDE_SCALE }))
  .combine(TransitionEffect.opacity(0).animation({ duration: TRANSITION_DURATION, curve: Curve.Sharp }));

  /**
   * 更新通知条目横向平移距离
   * SwipeCallback
   *
   * @param tranX 平移距离
   * @param isRemoveEntry 是否移除通知
   */
  onUpdateItemTranX(tranX: number, isRemoveEntry: boolean): void {
    tranX = this.addDamping(tranX); // 添加阻尼，防止横滑超出横幅窗口被裁剪
    this.closeVM?.setItemTranslate(tranX);
    this.clipTranslateAnimator?.pause();
    this.updateItemTranx(tranX);
    this.itemIsDeleting = isRemoveEntry;
  }

  addDamping(tranX: number): number {
    const showAtRight = !RTLUtil.isRTL();
    if (!showAtRight && tranX <= 0) {
      return tranX;
    } else if (showAtRight && tranX >= 0) {
      return tranX;
    }
    return this.calculateNewX(tranX);
  }

  calculateNewX(x: number): number {
    const k = 0.05; // 阻尼系数，控制阻尼效果的强度
    const x0 = this.innerMargin / 2; // 阻尼开始的滑动距离
    const L = this.innerMargin; // 最大滑动距离
    let isNegative = false;
    if (x < 0) {
      isNegative = true;
      x = -x;
    }
    x = x > x0 ? L * (Math.exp(k * (x - x0)) / (1 + Math.exp(k * (x - x0)))) : x;
    x = isNegative ? -x : x;
    return x;
  }

  /**
   * 更新通知条目横向平移动画
   * SwipeCallback
   *
   * @param itemAnim 动画
   */
  onUpdateItemAnim(itemAnim: AnimateParam): void {
    this.itemTranAnim = itemAnim;
  }

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  onNtfDataUpdate(newEntry: NotificationEntry): void {
    this.ntfEntry?.unregisterNtfOutListener(this);
    this.ntfEntry = newEntry;
    this.ntfEntry.registerNtfOutListener(this);
    this.swipeController?.setNtfEntry(newEntry);
  }

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  onNtfOutUpdate(): void {
    log.showInfo(`onNtfOutUpdate hashcode:${this.ntfEntry?.hashCode}`)
    this.myOutTransitionEffect = this.outNormalTransition;
  }

  /**
   * 获取通知数据
   * SingleItemCallback
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry {
    return this.ntfEntry as NotificationEntry;
  }

  /**
   * 获取通知面板类型
   * SingleItemCallback
   *
   * @return 通知面板类型
   */
  getNtfType(): number {
    return this.notificationType;
  }

  private ntfOnTouch = (event: TouchEvent): void => {
    if (event.type === TouchType.Move) {
      if (this.itemClickScale !== 1 &&
        Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 2 ||
        Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 2) {
        this.itemClickScale = 1;
      }
      return;
    }

    if (event.type === TouchType.Down) {
      this.itemClickScale = 0.95;
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;
      return;
    }

    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.itemClickScale = 1;
      return;
    }
  }

  private itemClickEvent = () => {
    log.showInfo('on item click: ' + this.ntfEntry?.toSimpleString() + ', ' + this.itemTranX);
    if (this.itemTranX != 0) {
      // 只有当通知没有位移时才允许点击
      return;
    }
    if (!this.immersiveState?.isImmersive || !this.checkWrapper.checkBool() || this.isExpand) {
      this.myOutTransitionEffect = this.outNormalTransition;
    }
    this.itemVm?.onItemClick(this.isHeadsUp, 1);
    if (this.ntfEntry && this.ntfEntry.isCollaNotification) {
      this.headsUpVM?.removeEntry(this.ntfEntry);
    }
  }

  private handleActionStart(event? : GestureEvent) {
    if (!event) {
      return;
    }

    Trace.start(Trace.CORE_METHOD_NOTIFICATION_SWIPE + '_' + TAG);
    log.showInfo(`PanGesture onActionStart: ${event.offsetX}`);
    this.swipeController?.onStartSwipe(event);
    this.itemScaleX = 1;
    this.itemScaleY = 1;
    this.headsUpVM?.setIsGestureActioning(this.ntfEntry as NotificationEntry, true);
  }

  private handleActionUpdate(event? : GestureEvent) {
    if (!event) {
      return;
    }
    this.swipeController?.onUpdateSwipe(event);
  }

  private handleActionEnd(event? : GestureEvent) {
    if (!event) {
      return;
    }
    log.showInfo(`PanGesture onActionEnd: ${event.offsetX}`);
    this.swipeController?.onEndSwipe(event);

    Trace.end(Trace.CORE_METHOD_NOTIFICATION_SWIPE + '_' + TAG);
    this.headsUpVM?.setIsGestureActioning(this.ntfEntry as NotificationEntry, false);
  }

  private handleActionCancel() {
    this.swipeController?.onCancelSwipe();
    Trace.end(Trace.CORE_METHOD_NOTIFICATION_SWIPE + '_' + TAG);
    this.headsUpVM?.setIsGestureActioning(this.ntfEntry as NotificationEntry, false);
  }

  /**
   * 窗口可见性切换
   */
  private onWindowShowChange(): void {
    if (this.isNtfWindowShow) {
      return;
    }
    // 当窗口隐藏时，收起横滑状态
    this.swipeController?.swipe2Collapse();
  }

  private onItemHoverChange(isHover: boolean): void {
    log.showInfo(`onItemHoverChange ${isHover}`);
    if ((this.headsUpVM as NtfHeadsUpVM)?.setItemHoverState) {
      (this.headsUpVM as NtfHeadsUpVM).setItemHoverState(this.ntfEntry as NotificationEntry, isHover);
    }
    if (isHover) {
      this.closeVM?.setItemHover(this.ntfEntry!);
      this.closeVM?.updatePosition(this.ntfEntry!, this.itemContentArea!);
    } else {
      this.closeVM?.cancelItemHover(this.ntfEntry!);
    }
  }

  private updateItemTranx(tranX: number): void {
    // 在按钮裁剪区域内滑动使用自定义动画
    if (this.itemTranAnim != null && this.swipeController.checkIsInClipRange(tranX, this.itemTranX)) {
      this.onUpdateClipItemTranX(tranX);
      return;
    }
    this.updateItemTranxWithAnim(tranX);
  }

  private updateItemTranxWithAnim(tranX: number): void {
    if (this.itemTranAnim == null) {
      this.itemTranX = tranX;
    } else {
      animateTo(this.itemTranAnim, () => {
        this.itemTranX = tranX;
      })
    }
  }

  private onUpdateClipItemTranX(tranX: number): void {
    this.clipTranslateAnimator = this.swipeController.getClipTranslateAnimation(this.itemTranX, tranX);
    let _this = this
    this.clipTranslateAnimator.onframe = (value: number) => {
      _this.itemTranX = value;
    }
    this.clipTranslateAnimator.play();
  }

  onFloatingCapacityChanged(isSupportFloating: boolean): void {
    log.showInfo(`onFloatingCapacityChanged, ${isSupportFloating}`);
    this.isDropBarVisible = isSupportFloating;
  }

  private onDeformChanged(): void {
    if (this.bannerDeformState.bannerMaskingOpacity === 0 && (this.bannerDeformState.bannerHeight ?? 0 > 0)) {
      this.initHeight = this.bannerDeformState.bannerHeight;
    }
  }

  /**
   * 正在删除的通知item回调
   * 复写NtfCloseVM.NtfCloseCallback
   *
   * @param deletingItem 正在删除的通知
   */
  onDeletingItemChange(deletingItem: NotificationEntry | undefined): void {
    if (deletingItem) {
      this.closeVM?.cancelItemHover(this.ntfEntry);
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear:${this.ntfEntry?.hashCode}`);
    this.isDropBarVisible = this.bannerFloatingController?.isSupportFloating() ?? false;
    this.bannerFloatingController?.registerFloatingCapacityChangedListener(this);
    // 恢复默认展开状态
    this.itemVm.init(this);
    // 注册通知数据变更监听
    this.ntfEntry?.registerDataUpdateListener(this);
    this.ntfEntry?.registerNtfOutListener(this);
    // 注册条目横滑监听
    this.swipeController?.setNtfEntry(this.ntfEntry as NotificationEntry);
    this.swipeController.swipePercent = 0.2;
    this.swipeController?.setHeadsUpNtf(false); // PC横幅通知横滑动效和手机横幅通知横滑动效不一致
    this.swipeController?.registerSwipeCallback(this);
    this.onDeformChanged();
    this.closeVM?.registerNtfCloseListener(this);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    // 注销数据更新监听
    this.ntfEntry?.unregisterDataUpdateListener(this);
    this.ntfEntry?.unregisterNtfOutListener(this);
    // 注销条目横滑监听
    this.swipeController?.unregisterSwipeCallback(this);
    this.itemVm.onDestroy();
    this.clipTranslateAnimator = undefined;
    this.closeVM?.cancelItemHover(this.ntfEntry!);
    this.closeVM?.setItemTranslate(0);
    this.bannerFloatingController?.unregisterFloatingCapacityChangedListener(this);
    if (this.persistentId != 0) {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setFocusable(false);
    }
    this.closeVM?.unregisterNtfCloseListener(this);
  }

  @Builder
  buildContent() {
    if (this.immersiveState?.isImmersive && !this.isExpand) {
      NotificationContentInTint({
        bannerDeformState: this.bannerDeformState,
        persistentId: this.persistentId,
        isExpand: this.isExpand,
        arrowDownChild : (): void => { this.arrowDown() },
        checkWrapper: this.checkWrapper
      })
        .width('100%')
    } else {
      NotificationContent({
        isHeadsUp: true,
        bannerDeformState: this.bannerDeformState,
        persistentId: this.persistentId,
        timeVm: new NtfTimeVM(),
        colorModeVM: this.colorModeVM,
        radius: {
          bottomLeft: this.radius as Length,
          bottomRight: this.radius as Length
        },
        headsUpVM: this.headsUpVM
      })
        .width('100%')
    }
  }

  @Builder
  arrowDown() {
    Circle()
      .width($r('app.float.ntf_button_size_in_tint'))
      .height($r('app.float.ntf_button_size_in_tint'))
      .fill(this.colorModeVM?.immersiveCircleColor)

    SymbolGlyph($r('sys.symbol.chevron_down'))
      .draggable(false)
      .fontSize('20vp')
      .fontColor([this.colorModeVM?.immersiveArrowDownColor])
      .flexShrink(0)
  }

  onHidingHeadsUp() {
    log.showInfo(`start hiding animator. run onHidingHeadsUp:${this.isHidingHeadsUp}, blurRadius: ${this.blurRadius}}`);
    if (!this.isHidingHeadsUp) {
      return;
    }
    Trace.start(`onHidingHeadsUp`);
    setTimeout(() => {
      animateTo({
        duration: 200,
        curve: Curve.Friction,
        onFinish: () => {
          Trace.end(`onHidingHeadsUp`);
          log.showInfo(`finished hiding animator. set blurRadius: 0}`);
          this.blurRadius = 0;
        }
      }, () => {
        log.showInfo(`start hiding animator. set blurRadius: 20}`);
        this.blurRadius = 20.0;
      })
    }, 300);
  }

  @Builder
  buildHeadsUpItemPc() {
    Stack() {
      this.buildContent();
    }
    .border({ width: $r('app.float.ntf_pc_banner_inner_boarder_width'), color: $r('app.color.ntf_pc_banner_inner_boarder_color'), radius: $r('app.float.ntf_pc_banner_inner_boarder_radius') })
    .outline({ width: $r('app.float.ntf_pc_banner_outer_boarder_width'), color: $r('app.color.ntf_pc_banner_outer_boarder_color'), radius: $r('app.float.ntf_pc_banner_outer_boarder_radius') })
    .alignContent(Alignment.Start)
    .gesture(PanGesture({ direction: PanDirection.Up }).onActionEnd((event) => {
      if (this.ntfEntry && event != undefined && event.offsetY < UP_MOVE_DISTANCE) {
        HiDfxEventUtil.reportSwipeIgnoreBannerNotification(this.ntfEntry.creatorBundleName);
        this.headsUpVM?.removeEntry(this.ntfEntry);
      }
    }))
  }

  handleNewArea(newValue: Area) {
    this.itemContentArea = newValue;
    this.swipeController?.setItemWidth(newValue.width as number);
    if (!this.ntfEntry) {
      return;
    }
    this.onContentAreaChange?.(newValue, this.ntfEntry);
    this.closeVM?.updatePosition(this.ntfEntry, this.itemContentArea);
  }

  build() {
    Stack() {
      if (!CommonUtils.isInvalid(this.ntfEntry)) {
        Column() {
          this.buildHeadsUpItemPc();
        }
        .visibility(this.closeVM?.deletingItem === this.ntfEntry ? Visibility.Hidden : Visibility.Visible)
        .onAreaChange((oldValue, newValue) => {
          this.handleNewArea(newValue);
        })
        .backgroundColor(this.bgColor)
        .backgroundBrightnessInternal(this.colorModeViewData.statusBarPanelOption)
        .backgroundEffect({ policy: 1, radius: this.currColorMode === ColorMode.LIGHT ? 80 : 50 })
        .translate({ x: this.itemTranX })
        .shadow(this.shadowStyle ? this.shadowStyle : notificationStyle.item.shadow)
        .borderRadius(this.radius)
        .width('100%')
        .scale({ x: this.itemClickScale, y: this.itemClickScale })
        .animation(NotificationConfig.NOTIFICATION_CLICK_ANIM)
        .hitTestBehavior(this.isGestureDisable ? HitTestMode.None : HitTestMode.Default)
        .onHover(this.closeVM ? (isHover: boolean) => { this.onItemHoverChange(isHover) } : null)
        .onTouch(this.ntfOnTouch)
        .gesture(GestureGroup(GestureMode.Exclusive,
          GestureGroup(GestureMode.Parallel,
            // 当swipe展开时，点击收起swipe
            TapGesture({ count: 1 }).onAction(this.itemClickEvent)
          ),
          GestureGroup(GestureMode.Parallel,
            // 横滑触摸手势
            PanGesture({ direction: PanDirection.Horizontal, distance: NtfItemSwipeController.SWIPE_DISTANCE })
              .onActionStart((event?: GestureEvent) => this.handleActionStart(event))
              .onActionUpdate((event?: GestureEvent) => this.handleActionUpdate(event))
              .onActionEnd((event?: GestureEvent) => this.handleActionEnd(event))
              .onActionCancel(() => this.handleActionCancel())
          )))
      }
    }
    .transition(TransitionEffect.asymmetric(this.outNormalTransition, this.myOutTransitionEffect))
    .margin(this.getContentMargin())
  }

  getContentMargin(): Length | Padding | LocalizedPadding {
    return this.isBlocked ? {
      top: CONTENT_MARGIN_TOP
    } : {
      bottom: CONTENT_MARGIN_BOTTOM + DEFAULT_BORDER_SIZE
    };
  }
}
