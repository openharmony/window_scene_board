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
import { NotificationMenuRow } from '../common/NotificationMenuRow';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { ntfSettingsDC as NtfSettingsDC } from '../../controller/NtfSettingsDialogController';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper, EventManager, EvtBus, sEventManager, TargetPanel, unsubscribe, } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  DropdownPanelChangeFinishedEvent,
  NtfListScrollEvent,
  ResetItemSwipeEvent
} from '../../common/event/NotificationEvent';
import GroupChildNtfDataChannel from '../../vm/GroupChildNtfDataChannel';
import { NotificationConstants } from '../../common/NotificationConstants';
import { NotificationHideContentItem } from './NotificationHideContentItem';
import { NotificationContent } from './NotificationContent';
import curves from '@ohos.curves';
import { image } from '@kit.ImageKit';
import {
  AccessibilityUtil,
  BannerDeformState,
  bannerMgr,
  FrameCount,
  immersiveKgMgr,
  IState,
  LiveBaseTemplate,
  LiveType,
  LiveUseScene,
  LiveViewData,
  OnStateChangeListener,
  OverlayIconStyle,
  StateType,
  SysTypeCode,
} from '@ohos/systemuicommon';
import { DropDownPanelManager, OverlayAnimData } from '@ohos/systemuicommon/Index';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import { NotificationType } from '../../common/NotificationType';
import {
  ScreenLockNotificationConst
} from '@ohos/screenlockcommon/src/main/ets/constants/ScreenLockNotificationConstants';
import { NotificationConfig } from '../../common/NotificationConfig';
import { NotificationItemStyle } from '../../vm/style/NotificationItemStyle';
import { DEFAULT_CLIP, NtfClipAnimStyle } from '../../common/NtfClipAnimStyle';
import { componentUtils, LengthMetrics } from '@kit.ArkUI';
import { SlNtfItemWidth } from '../../common/SlNtfItemWidth';
import { NtfTimeVM } from '../../vm/NtfTimeVM';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NtfAnimVM } from '../../vm/NtfAnimVM';
import { ItemGestureModifier } from '../../model/NotificationGestureModifier';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { NotificationUtils } from '../../common/NotificationUtils';
import { NotificationAccessibilityUtil as AccessUtil } from '../../common/NotificationAccessibilityUtil';
import { AnimationController } from '@ohos/mediacontrolcomponent/src/main/ets/default/Controller/AnimationController';
import { NtfBrightnessMode, NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NtfSingleItemModifier, SingleItemAreaModifier } from '../../model/NtfItemModifier';
import { AnimationState } from '@ohos/mediacontrolcomponent/src/main/ets/default/viewmodel/AnimationState';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { NtfScrollAnimation } from '../../animation/NtfScrollAnimation';
import util from '@ohos.util';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { NotificationAnimationParas } from '../../common/NotificationAnimationParas';
import { PowerStatusEnum, PowerStatusMonitor } from '@ohos/screenlockcommon/src/main/ets/monitor/PowerStatusMonitor';
import { LiveCardShowAnimationEventUtil } from '@ohos/systemuicommon/newTsIndex';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

const TAG = 'NotificationSingleItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const KG_LOCK_SUFFIX = '_KGLOCK';
const KG_SUFFIX = '_KG';
const BUTTON_DISPLAY_ANIMATION_CURVE = curves.interpolatingSpring(0, 1, 225, 25);
const CLIP_HEIGHT = 30;
// 通知背板在AOD场景下的默认颜色
const DEFAULT_AOD_NTF_BACK_COLOR = 0xFF1E1E1E;

/**
 * 条目裁剪动效
 *
 * @param clipStyle 裁切样式
 */
@AnimatableExtend(Column)
function itemClip(clipStyle: NtfClipAnimStyle) {
  .clip(clipStyle.isRectClipEnable() ? new Rect({
    width: clipStyle.clipWidth,
    height: clipStyle.clipHeight,
    radius: clipStyle.clipRadius
  })
    .position({
      x: clipStyle.clipOffsetX,
      y: clipStyle.clipOffsetY
    }) : clipStyle.isSimpleClipEnable())
}

@Builder
export function buildDivider(isInGroup: boolean, colorModeVM: NtfColorModeVM | undefined, overlayIcon?: image.PixelMap, overlayStyle?: number) {
  if (isInGroup) {
    Divider()
      .strokeWidth('1px')
      .color(colorModeVM?.themeGroupDividerColor)
      .foregroundBrightness(colorModeVM?.themeForegroundDividerOption)
      .padding({
        start: LengthMetrics.resource((overlayIcon && overlayStyle !== OverlayIconStyle.REVERSE ?
        $r('app.float.ntf_center_header_phone_land_height') : $r('app.float.ntf_item_padding_start_end'))),
        end: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end'))
      })
      .transition(TransitionEffect.OPACITY.animation({
        duration: 333,
        curve: curves.cubicBezierCurve(0.20, 0.00, 0.20, 1.0)
      }))
  }
}

/**
 * 通知单条目组件
 *
 * @since 2022-12-10
 */
@Component
export struct NotificationSingleItem {
  /**
   * 当前通知条目可以显示左滑按钮
   */
  private canShowMenuRow: boolean = false;
  /**
   * 圆角
   */
  @Prop radius: number | null = null;

  /**
   * 通知数据
   */
  @Provide ntfEntry: NotificationEntry | undefined = undefined;

  /**
   * 获取所在组通知
   */
  public groupEntryCB: () => NotificationEntry | undefined = () => undefined;

  /**
   * 新的单通知实例
   */
  @Consume @Watch('onNewSingleNft') newSingleNft?: NotificationEntry;

  /**
   * 是否为横幅通知
   */
  private isHeadsUp: boolean = false;

  /**
   * 是否为分组中的条目
   */
  private isInGroup: boolean = false;

  /**
   * 是否为聚合中的条目
   */
  private isInAggregate: boolean = false;

  /**
   * 是否禁用手势
   */
  @Prop isGestureDisable: boolean = false;

  /**
   * 通知列表类型
   */
  @Consume notificationType: number;

  /**
   * 面板触摸事件down点
   */
  @Consume @Watch('onGlobalDownYChange') panelDownGlobalY: number;

  /**
   * 面板触摸事件down点X轴坐标
   */
  @Consume @Watch('onGlobalDownXChange') panelDownGlobalX: number;

  /**
   * 窗口是否可见
   */
  @Consume @Watch('onWindowShowChange') isNtfWindowShow: boolean;

  /**
   * 通知条目默认收起
   */
  @Provide isItemExpanded: boolean = false;

  @StorageLink('contract') @Watch('contractEvent') contract: boolean = false;

  /**
   * 隐藏通知内容时，1个通知
   */
  @Provide contentHideText: string = ' ';

  /**
   * 是否隐藏通知内容
   */
  @State isHideNtfContent: boolean = false;

  /**
   * 通知条目横向平移距离
   */
  @State itemTranX: number = 0;
  /**
   * 通知条目透明度
   */
  @State itemOpacity: number = 1;

  /**
   * 组通知当前分组横滑平移距离
   */
  @State groupItemTranX: number = 0;

  /**
   * 通知条目横向平移动画
   */
  private itemTranAnim: AnimateParam | null = null;

  @State itemClickScale: number = 1;
  private touchStartX: number = 0;
  private touchStartY: number = 0;

  /**
   * 条目VM
   */
  private itemVm: NtfSingleItemVM = new NtfSingleItemVM();

  /**
   * 横滑控制
   */
  private swipeController: NtfItemSwipeController = new NtfItemSwipeController();

  private unsubscribe?: unsubscribe;

  /**
   * close按钮VM
   */
  @Consume private closeVM?: NtfCloseVM;

  @State singleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(this.swipeController, this.closeVM);

  persistentId: number = 0;

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 组通知与子通知数据交换
   */
  private groupChildNtfDataChannel?: GroupChildNtfDataChannel;
  private groupTranslateXCallback?: (transX: number) => void;
  /**
   * 横竖屏转换
   */
  @StorageLink('isLandscape') isLandscape: boolean = false;

  /**
   * 组通知最后一个Item的hash code，用于判断是否是最后一个item。
   */
  @Prop lastItemHashCode: string = '';
  /**
   * 组通知第一个item的hash code
   */
  @Prop firstItemHashCode: string = '';

  /**
   * 记录左滑状态的通知的哈希值，用于左滑状态互斥（同一时刻，只允许一条通知左滑）
   */
  @Consume @Watch('onSwipeIdChange') swipeHashCode: string;

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  private isUseEffect: boolean = false;

  /**
   * 是否已经主动聚焦过展开按钮后的整个卡片组件
   */
  private hasRequestFocusExpandedCard: boolean = false;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 动效vm
   */
  @State ntfAnimVM: NtfAnimVM | undefined = undefined;

  /**
   * 索引
   */
  private index: number = 0;
  /**
   * 索引
   */
  private lastIndex: number = 0;

  /**
   * 记录通知是否被拖动过，用于控制menu加载
   */
  @State isDragged: boolean = false;
  /**
   * 是否显示通知时间
   */
  private showDateTime: boolean = true;
  /**
   * 第一条更多通知的动效延迟时间
   */
  private fisrtExtraNtfDelayTime: number | undefined = undefined;

  /**
   * 通知阴影效果
   */
  private shadowStyle?: ShadowOptions | ShadowStyle;

  /**
   * 形变相关参数
   */
  @Prop bannerDeformState: BannerDeformState = new BannerDeformState();

  @Prop isInitParam: boolean = false;

  @Prop itemTranslateY: number = 0;

  private hasCalledAboutToDisappear: boolean = false;

  /**
   * 记录展示按钮的通知的哈希值，用于互斥操作
   */
  @Consume @Watch('onDisplayButtonsHashCodeChanged') displayButtonsHashCode: string;

  /**
   * 锁屏是否加锁状态
   */
  @Consume @Watch('onLockStateChange') isKeyguardLock: boolean;

  /**
   * 条目裁切高度
   */
  @Prop itemClipHeight: number = -1;

  /**
   * 条目裁切纵向偏移
   */
  @Prop itemClipOffsetY: number = 0;

  /**
   * 锁屏条目宽度记录
   */
  @State slItemWidth?: SlNtfItemWidth = undefined;

  /**
   * 通知条目样式
   */
  @State itemStyle: NotificationItemStyle = notificationStyle.item;

  /**
   * 分帧处理对象，仅需要记录到第2帧
   */
  @State frameCount: FrameCount = new FrameCount();

  private singleItemId: string = TAG;
  /**
   * 记录展示按钮的通知的哈希值
   */
  @Consume displayedNtfHashCode: string;

  @State itemGestureModifier: ItemGestureModifier = new ItemGestureModifier();

  /**
   * 条目按钮可见性切换回调
   */
  private itemActionBtnChange?: (anim: AnimateParam) => void;
  /**
   * 卡片上滑偏移量
   */
  @Prop @Watch('onNtfItemTranslateYChanged') ntfItemTranslateY: number = 0;
  /**
   * 临时关闭模糊
   */
  @Prop isTempDisableEffect: boolean = false;
  /**
   * 卡片裁剪参数
   */
  @State clipParam: boolean | RectAttribute = false;
  /**
   * 卡片高度
   */
  private itemHeight: number = 0;
  /**
   * 卡片宽度
   */
  private itemWidth: number = 0;
  /**
   * 是否组通知展开(实际含义：当前是否在组通知展开或收起的过程中)
   */
  @Prop @Watch('onClickStatusChanged') isClicked: boolean = false;
  /**
   * 是否开启提亮，默认开启
   */
  private isColorModeEnable: boolean = true;

  /**
   * 是否为通知中心通知
   */
  private isNtfCenterGroupItem: boolean = false;
  /**
   * 是否是更多通知折叠展开场景
   */
  private isExtraItemClicked: boolean = false;
  private isRTL: boolean = RTLUtil.isRTL();

  @Prop isItemEnable: boolean = true;

  private ntfProductConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  private ancestorsOverlayAnimData?: OverlayAnimData[];

  @State @Watch('overlayAnimDataChanged') overlayAnimData: OverlayAnimData = new OverlayAnimData();

  @Prop isDropDownAniFin: boolean = false;

  @State protectedVm: AppProtectedVm = AppProtectedVm.get();
  @Prop ntfCount: number = 1;
  @Prop @Watch('onLockStateChange') isNeedPanelInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop @Watch('onLockStateChange') isLockScreen: boolean = false;
  @Prop @Watch('onLockStateChange') isSecureAndLocked: boolean = false;
  /**
   * 通知列表滑动动效
   */
  private ntfScrollAnimation: NtfScrollAnimation = new NtfScrollAnimation();
  /**
   * 锁屏一镜到底动效状态
   */
  @State mediaAnimState: AnimationState = AnimationController.getAnimationState();

  @ObjectLink ntfAniParameters: NotificationAnimationParas;

  @State itemClipParam: boolean | RectAttribute = false;

  @State singleItemAreaModifier: SingleItemAreaModifier | undefined =
    this.isInGroup ? undefined : new SingleItemAreaModifier(this.ntfAniParameters, this.isInGroup);

  /**
   * 是否扩展新形态小外屏
   */
  @Prop isOuterHomeFolded: boolean = false;

  @State hoverScaleRate: number = 1;

  overlayAnimDataChanged(): void {
    log.showInfo('overlayAnimDataChanged to %{public}s', this.overlayAnimData.toStr());
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear:${this.ntfEntry?.hashCode}`);
    this.overlayAnimData.setTag(`${TAG}_${this.ntfEntry?.hashCode}`);
    this.singleItemId += `_${this.ntfEntry?.hashCode}`
    // 恢复默认展开状态
    this.isItemExpanded = this.ntfEntry?.isItemExpanded ?? false;
    this.refreshMenuRowStatus(this.ntfEntry);
    this.itemVm.init(this);
    // 注册通知数据变更监听
    this.ntfEntry?.registerDataUpdateListener(this);
    // 注册条目横滑监听
    if (this.swipeController) {
      this.swipeController.setNtfEntry(this.ntfEntry as NotificationEntry);
      this.swipeController.setSettingsIgnore(this.ntfEntry?.isSettingIgnore ?? false);
      this.swipeController.setHeadsUpNtf(this.isHeadsUp);
      this.swipeController.setIsInGroup(this.isInGroup);
      this.swipeController.registerSwipeCallback(this);
      this.swipeController.setGroupEntryCB(this.groupEntryCB);
    }
    this.eventMgr.on(NtfListScrollEvent, this.onNtfListScrollEvent);
    this.eventMgr.on(ResetItemSwipeEvent, this.onCloseSwipeEvent);
    this.eventMgr.on(DropdownPanelChangeFinishedEvent, this.dropdownPanelChanged);
    this.setNtfHideContentState(this.ntfEntry as NotificationEntry);
    this.refreshNtfCount();
    this.groupTranslateXCallback = this.onGroupTranslateX;
    this.groupChildNtfDataChannel?.registerGroupTranslateCallback(this.groupTranslateXCallback);
    if (NotificationType.isKeyguard(this.notificationType)) {
      this.subscribeEvent(this.ntfEntry, true);
      this.slItemWidth = this.swipeController?.getSlItemWidth();
      this.unsubscribe = sEventManager.subscribe(
        ScreenLockNotificationConst.SCREENLOCK_NTF_NEED_TO_SWIPE_TO_COLLAPSE,
        (forceReset: boolean) => {
          if (!this.isSwipeExpand()) {
            return;
          }
          this.swipeController?.swipe2Collapse();
          if (forceReset) {
            this.itemTranX = 0;
          }
        });
    }

    if (!NotificationType.isKeyguard(this.notificationType)) {
      this.frameCount.start(2);
    }
    this.initItemGestureModifier();
    this.updateClipParamByGroupStatus();
    this.singleItemModifier.setEntry(this.ntfEntry);
  }

  private subscribeEvent(ntf: NotificationEntry | undefined, isSubscribe:boolean): void {
    if (!SystemUICcmConfig.instance.isEnabledLive2) {
      return;
    }
    if (!ntf) {
      return;
    }
    if (!ntf.isLiveType()) {
      return;
    }
    const liveCardType = ntf.liveViewData?.liveType;
    if (liveCardType !== LiveType.FLIGHT) {
      log.showInfo(`live is not flight ${liveCardType}`)
      return;
    }
    if (isSubscribe) {
      log.showInfo(`subscribe event for ${ntf?.hashCode}`);
      immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.immersiveStateListener);
      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_DISPLAY_ON, this.displayOn);
    } else {
      log.showInfo(`unsubscribe event for ${ntf?.hashCode}`);
      immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.immersiveStateListener);
      PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.BEGIN_DISPLAY_ON, this.displayOn);
    }
  }

  private dropdownPanelChanged = (event: DropdownPanelChangeFinishedEvent) => {
    // 收起通知面板时更新
    if (!event.isShow && event.currPanel === TargetPanel.NOTIFICATION_PANEL && this.ntfItemTranslateY === 0) {
      this.onNtfItemTranslateYChanged();
    }
  }

  onClickStatusChanged(): void {
    this.updateClipParamByGroupStatus();
  }
  private onNtfListScrollEvent = (): void => {
    if (this.itemTranX === 0) {
      return;
    }
    this.swipeController?.swipe2Collapse();
  }

  /**
   * 监听transY变化，处理通知中心实况卡片裁剪
   */
  onNtfItemTranslateYChanged(): void {
    const isItemSizeInvalid = !this.itemWidth || !this.itemHeight;
    if (!this.isShouldRectClipInDropdown() || isItemSizeInvalid) {
      return;
    }
    // 面板收起过程中将裁剪参数复原
    if (DropDownPanelManager.isPanelDismissing() || this.ntfItemTranslateY === 0 ||
      !this.ntfAniParameters?.isStacking()) {
      this.clipParam = false;
    } else if (this.ntfItemTranslateY > 0 && this.ntfAniParameters?.isStacking()) {
      this.clipParam = new Rect({
        width: '100%',
        height: Math.min(this.itemHeight, this.itemHeight - this.ntfItemTranslateY + CLIP_HEIGHT),
        radius: this.radius ?? 0
      })
    } else if (this.ntfItemTranslateY < 0 && this.ntfAniParameters?.isStacking()) {
      const clipHeight = Math.min(this.itemHeight, this.itemHeight + this.ntfItemTranslateY + CLIP_HEIGHT);
      this.clipParam = new Rect({
        width: '100%',
        height: clipHeight,
        radius: this.radius ?? 0
      }).position({ y: this.itemHeight === clipHeight ? 0 : -this.ntfItemTranslateY - CLIP_HEIGHT })
    }
  }

  private isShouldRectClipInDropdown(): boolean {
    return NotificationType.isDropdown(this.notificationType) && (this.ntfEntry as NotificationEntry)?.isLiveType();
  }

  onDisplayButtonsHashCodeChanged() {
    log.showInfo('OnDisplayButtonsHashCodeChanged %{public}s, %{public}s', this.displayButtonsHashCode,
      this.displayedNtfHashCode);

    if (this.displayButtonsHashCode === '') {
      this.displayedNtfHashCode = '';
    }
  }

  onSwipeIdChange() {
    log.showDebug(`onSwipeIdChange:${this.ntfEntry?.hashCode}, ${this.swipeHashCode}}`);
    if (this.ntfEntry?.hashCode !== this.swipeHashCode && this.swipeHashCode != '' && !this.swipeController.isRemoving) {
      this.onUpdateItemTranX(0, false);
    }
  }

  onCloseSwipeEvent = (event: ResetItemSwipeEvent) => {
    if (CommonUtils.isInvalid(this.ntfEntry) || CommonUtils.isInvalid(event)) {
      return;
    }
    if (this.ntfEntry && !this.ntfEntry.isGroup && this.ntfEntry.hashCode === event?.ntfHashCode) {
      this.swipeController?.swipe2Collapse();
    }
  }

  /**
   * 沉浸式状态变化回调
   */
  private immersiveStateListener: OnStateChangeListener = {
    onStateChange: (state: IState): void => {
      log.showInfo(`OnStateChangeListener %{public}s`, this.ntfEntry?.hashCode);
      if (state.getStateType() === StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE) {
        if (immersiveKgMgr.getImmersiveDisplayState().isShowList()) {
          log.showInfo(`isShowList`, this.ntfEntry?.hashCode);
          LiveCardShowAnimationEventUtil.setLiveCardAnimation();
        } else if (immersiveKgMgr.getImmersiveDisplayState().isCapsule()) {
          log.showInfo(`isCapsule`, this.ntfEntry?.hashCode);
          LiveCardShowAnimationEventUtil.setLiveCardAnimation();
        } else if (immersiveKgMgr.getImmersiveDisplayState().isShowCard()) {
          log.showInfo(`isShowCard`, this.ntfEntry?.hashCode);
        }
      }
    }
  };

  /**
   * 监听收起的事件
   */
  private contractEvent(): void {
    if (this.contract) {
      this.isDragged = false;
      this.displayButtonsHashCode = '';
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear %{public}s`, this.ntfEntry?.hashCode);
    this.subscribeEvent(this.ntfEntry, false);
    this.hasCalledAboutToDisappear = true;
    this.eventMgr.offAll();
    // 清空缓存
    if (this.ntfEntry && this.groupTranslateXCallback) {
      // 注销数据更新监听
      this.ntfEntry?.unregisterDataUpdateListener(this);
      // 注销条目横滑监听
      this.swipeController?.unregisterSwipeCallback(this);
      this.itemVm.onDestroy();
      this.groupChildNtfDataChannel?.unRegisterGroupTranslateCallback(this.groupTranslateXCallback);
    }
    this.swipeController.setGroupEntryCB(() => undefined);
    this.closeVM?.cancelItemHover(this.ntfEntry!);
    this.closeVM?.setItemTranslate(0);
    this.refreshSwipeHashCode();
    if (this.unsubscribe != undefined) {
      this.unsubscribe();
    }
    this.deinitItemGestureModifier();
    if (NtfSettingsDC.getNtfEntryByType(this.notificationType)?.hashCode === this.ntfEntry?.hashCode) {
      NtfSettingsDC.hideDialog(this.notificationType)
    }
  }

  refreshSwipeHashCode(): void {
    if (this.isKeyguardLock && this.swipeHashCode != '' && this.ntfEntry?.hashCode === this.swipeHashCode) {
      log.showInfo(`about to disappear, reset own swipeHashCode`);
      this.swipeHashCode = '';
    }
  }

  private refreshNtfCount(): void {
    let groupEntry = this.groupEntryCB();
    if (!groupEntry) {
      log.showWarn('groupEntry is undefined!');
    } else if (groupEntry.childrenEntry) {
      this.ntfCount = groupEntry.childrenEntry.length;
    }
  }

  onUpdateItemOpacity(opacity: number): void {
    this.itemOpacity = opacity
  }

  /**
   * 更新通知条目横向平移距离
   * SwipeCallback
   *
   * @param tranX 平移距离
   * @param isRemoveEntry 是否移除通知
   */
  onUpdateItemTranX(tranX: number, isRemoveEntry: boolean): void {
    this.closeVM?.setItemTranslate(tranX);
    this.updateItemTranxWithAnim(tranX);
    AccessUtil.sendNtfRemoveAccessibility(isRemoveEntry);
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
    // 锁屏通知数据变化动效刷新
    if (this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD &&
      this.itemStyle?.itemUpdateAnim) {
      animateTo(this.itemStyle?.itemUpdateAnim, () => this.ntfEntry = newEntry);
    } else {
      this.ntfEntry = newEntry;
    }
    this.swipeController?.setNtfEntry(newEntry);
    this.setNtfHideContentState(newEntry);
    this.singleItemModifier.setEntry(newEntry);
    this.refreshMenuRowStatus(newEntry);
    if (newEntry.isLiveType() && newEntry.liveViewData?.liveType === LiveType.FLIGHT) {
      LiveCardShowAnimationEventUtil.setLiveCardAnimation();
    }
  }

  /**
   * 刷新当前通知是否有左滑menu按钮
   */
  private refreshMenuRowStatus(ntfEntry: NotificationEntry | undefined): void {
    if (!ntfEntry) {
      this.canShowMenuRow = false;
      return;
    }
    const canDel = ntfEntry.canDelete();
    const isNeedSetting = ntfEntry.canShowSetting(this.notificationType, this.isInGroup,
      ntfViewConfigManager.getListContentConfig().isOuterHome);
    this.canShowMenuRow = canDel || isNeedSetting;
  }

  private displayOn = () => {
    if (immersiveKgMgr.getImmersiveDisplayState().isShowList()) {
      log.showInfo(`display on ${this.ntfEntry?.hashCode}`);
      LiveCardShowAnimationEventUtil.setLiveCardAnimation();
    }
  }

  /**
   * 获取当前通知卡片的无障碍描述文本
   * @returns
   */
  private getAccessibilityDescription(): string {
    if (this.canShowMenuRow) {
      return AccessUtil.getSwipeDescription(this.isAccessibilityMode, this.itemTranX !== 0);
    }
    return '';
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

  getGroupEntry(): NotificationEntry | undefined{
    return this.groupEntryCB();
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

  /**
   * 判断是否为分组中的条目
   *
   * @returns 是否为分组中的条目
   */
  getIsInGroup(): boolean {
    return this.isInGroup;
  }

  getIsInAggregate(): boolean {
    return this.isInAggregate;
  }

  getIsLastInGroup(): boolean {
    return this.ntfEntry != undefined && this.lastItemHashCode === this.ntfEntry.hashCode;
  }

  getOverlayAnimData(): OverlayAnimData {
    return this.overlayAnimData;
  }

  getAncestorsOverlayAnimData(): OverlayAnimData[] {
    return this.ancestorsOverlayAnimData ?? [];
  }

  private isFrameValid(): boolean { // 分帧有效性
    if (NotificationType.isKeyguard(this.notificationType)) { // 锁屏面板不分帧
      return true;
    }
    if (this.newSingleNft || DeviceHelper.isPC()) {
      // 组通知变单通知场景不分帧
      return true;
    }
    return this.frameCount.value > 1;
  }

  getScaleAnim() : AnimateParam | undefined {
    return this.itemClickScale < 1 ? NotificationConfig.NOTIFICATION_CLICK_ANIM : undefined;
  }

  getTransitionEffect() {
    if (this.isInGroup && this.lastItemHashCode === this.ntfEntry?.hashCode) {
      return TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({ duration: 200, delay: 100, curve: Curve.Friction }), TransitionEffect.IDENTITY);
    } else {
      return undefined;
    }
  }
  /**
   * 通用条目控件
   */
  @Builder
  singleItem() {
    Stack({alignContent: Alignment.Bottom}) {
      Stack({ alignContent: this.overlayAnimData.isAnimating ? Alignment.Center : Alignment.End }) {
        if (this.isExtraItemClicked || this.isInGroup || this.isFrameValid()) { // 分帧处理:从第2帧开始创建子组件
          this.itemLayoutContent()
        }
      }
      .accessibilityLevel('no')
      .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentWidth : '100%')
      .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentHeight : undefined)
      .onGestureJudgeBegin((info) => {
        return this.swipeController?.onGestureJudgeBegin(this.notificationType, info);
      })
      .gestureModifier(this.itemGestureModifier)

      if (!this.getIsLastInGroup()) {
        buildDivider(this.isInGroup, this.colorModeVM, this.ntfEntry?.overlayIcon, this.ntfEntry?.overlayIconStyle)
      }
    }
    .id(this.getSingleItemContentId())
    .width('100%')
    .scale({
      x: this.getScale(),
      y: this.getScale()
    })
    .onHover((isHover: boolean) => {
      this.hoverScaleRate = (isHover && this.isInGroup) ? 1.02 : 1;
    })
    .onSizeChange((oldArea, newArea) => {
      this.itemHeight = Number(newArea.height) ?? 0;
      this.itemWidth = Number(newArea.width) ?? 0;
      if (oldArea.height !== newArea.height || oldArea.width !== newArea.width) {
        log.showInfo(`ntf hashCode: ${this.ntfEntry?.hashCode}, width: ${this.itemWidth}, height: ${this.itemHeight}`);
        this.onNtfItemTranslateYChanged();
      }
    })
    .zIndex(this.closeVM?.isDeletingItem(this.ntfEntry) ? -1 : 0)
    .animation(this.getScaleAnim())
    .hitTestBehavior((this.isGroupNtfSwipedOpen() || this.isGestureDisabled()) ? HitTestMode.None : HitTestMode.Default)
    .onClick(this.isAccessibilityMode ?
      (this.isKeyguardLock && !this.isInGroup ? () => this.itemTwiceClickEvent() : () => this.itemClickEvent()) : undefined)
    .onGestureJudgeBegin((info) => {
      return this.swipeController?.onGestureJudgeBegin(this.notificationType, info);
    })
    .gesture(
      GestureGroup(GestureMode.Parallel,
        // 横滑触摸手势
        PanGesture({
          direction: PanDirection.Horizontal,
          distance: NtfItemSwipeController.SWIPE_DISTANCE
        })
          .onActionStart((event?: GestureEvent) => this.handleActionStart(event))
          .onActionUpdate((event?: GestureEvent) => this.handleActionUpdate(event))
          .onActionEnd((event?: GestureEvent) => this.handleActionEnd(event))
          .onActionCancel(() => this.handleActionCancel())
      ))
    .onTouch(this.isInGroup ? undefined : this.ntfOnTouch)
    .transition(this.getTransitionEffect())
    .accessibilityLevel('no')
    .attributeModifier(this.singleItemAreaModifier)
  }

  build() {
    if (!CommonUtils.isInvalid(this.ntfEntry)) {
      this.singleItem();
    }
  }

  @Builder
  itemContent() {
    // backgroundBrightnessInternal接口需要在useEffect之后生效，因此抽取一层出来使用该接口
    Column() {
      // 隐藏通知内容（通知中心面板不隐藏通知）
      if (this.isHideNtfContent &&
        !NotificationType.isDropdown(this.notificationType) &&
        !NotificationType.isBanner(this.notificationType) &&
        !(NotificationType.isPc(this.notificationType) && !this.isHeadsUp) &&
        !(this.ntfEntry as NotificationEntry).isLiveType()) {
        NotificationHideContentItem(
          { colorModeVM: this.colorModeVM }
        )
          .padding({
            top: $r('app.float.ntf_item_padding_start_end'),
            bottom: $r('app.float.ntf_item_padding_start_end'),
            left: $r('app.float.ntf_item_padding_start_end'),
            right: $r('app.float.ntf_item_padding_start_end')
          })
          .id(NotificationConstants.getNTFSingleItemCompId(LiveUseScene.SCENE_NTF_CENTER, this.ntfEntry?.hashCode!))
      } else { // 普通通知
        NotificationContent({
          ntfCount: this.ntfCount,
          isInAggregate: this.isInAggregate,
          isInGroup: this.isInGroup,
          index: this.index,
          lastIndex: this.lastIndex,
          timeVm: this.showDateTime ? (new NtfTimeVM()) : undefined,
          colorModeVM: this.colorModeVM,
          fisrtExtraNtfDelayTime: this.fisrtExtraNtfDelayTime,
          radius: this.getBorderRadius(),
          textTranAnimParam: this.getTextTranAnimParam(),
          isClicked: this.isClicked,
          firstItemHashCode: this.firstItemHashCode,
          ntfItemVM: this.itemVm,
          isNeedBannerInScreenLock: this.isNeedPanelInScreenLock,
          isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
          isLockScreen: this.isLockScreen,
          isOuterHomeFolded: this.isOuterHomeFolded,
        })
          .id(NotificationConstants.getNTFSingleItemCompId(LiveUseScene.SCENE_NTF_CENTER, this.ntfEntry?.hashCode!))
          .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentWidth : undefined)
          .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentHeight : undefined)
          .opacity(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentOpacity : undefined)
      }
    }
    .justifyContent(FlexAlign.Center)
    .width(this.overlayAnimData.isAnimating ? '100%' : undefined)
    .height(this.overlayAnimData.isAnimating ? '100%' : undefined)
    .backgroundColor(this.getBackgroundColor())
    .backgroundBrightnessInternal(this.getBrightnessInternal())
    .borderRadius(this.getBorderRadius())
    .clip(this.itemClipParam)
  }

  private getBrightnessInternal(): BrightnessOptions | undefined {
    if (this.isUseColorMode()) {
      return ((this.ntfEntry as NotificationEntry).isLiveType() ? this.colorModeVM?.liveBgBrightnessOption :
        this.colorModeVM?.themeBgBrightnessOption)
    }
    return undefined;
  }

  private getBackgroundColor(): ResourceColor | undefined {
    if (!this.isUseColorMode()) {
      return undefined;
    }

    return ((this.ntfEntry as NotificationEntry)?.isLiveType() ? this.colorModeVM?.liveNtfItemBgColor :
      this.colorModeVM?.themeBgColor)
  }

  @Styles
  contentCommonProperty(){
    .onClick(this.isAccessibilityMode ?
      (this.isKeyguardLock && !this.isInGroup ? () => this.itemTwiceClickEvent() : () => this.itemClickEvent()) :
      undefined)
    .id(TAG + '_Single_' + this.ntfEntry?.hashCode)
    .accessibilityLevel('yes')
    .accessibilityDescription(this.getAccessibilityDescription())
    .transition(this.ntfEntry && this.ntfAnimVM?.getNtfItemTransition(this.ntfEntry))
    .visibility(this.closeVM?.deletingItem === this.ntfEntry
      && !DeviceHelper.isPC() ? Visibility.Hidden : Visibility.Visible)
    .attributeModifier(this.singleItemModifier)
    .translate({ x: this.itemTranX, y: this.overlayAnimData.isAnimating ? this.overlayAnimData.transY : 0 })
    .opacity(this.overlayAnimData.isAnimating ? this.overlayAnimData.bgOpacity : this.itemOpacity)
    .shadow(this.getItemShadow())
    .borderRadius(this.getBorderRadius())
    .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.bgWidth : '100%')
    .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.bgHeight : undefined)
    .useEffect(this.isEffectEnable())
  }

  @Builder
  itemLayoutContent() {
    if (NotificationType.isDropdown(this.notificationType)) {
      Column() {
        this.itemContent();
      }.justifyContent(FlexAlign.Center)
      .clip(this.clipParam)
      .pointLight({
        illuminated: (NotificationType.isKeyguard(this.notificationType) && !this.isInGroup) ?
        IlluminatedType.BORDER : IlluminatedType.NONE
      }).contentCommonProperty()
    } else {
      Column() {
        this.itemContent();
      }.justifyContent(FlexAlign.Center)
      .itemClip(this.getItemClipStyle())
      .pointLight({
        illuminated: (NotificationType.isKeyguard(this.notificationType) && !this.isInGroup) ?
        IlluminatedType.BORDER : IlluminatedType.NONE
      }).contentCommonProperty()
    }

    // 左滑menu按钮
    if (this.isDragged && this.canShowMenuRow) {
      NotificationMenuRow({
        ntfEntry: this.getNtfEntry(),
        swipeController: this.swipeController,
        isInGroup: this.isInGroup,
        colorModeVM: this.colorModeVM
      })
        .width(-this.itemTranX)
        .zIndex(-1)
    }
  }

  /**
   * 处理组通知展开收起裁剪参数
   */
  private updateClipParamByGroupStatus(): void {
    this.clipParam = !this.isClicked;
  }

  private getItemShadow(): ShadowOptions | ShadowStyle | null | undefined {
    if (this.isTempDisableEffect) { // 关闭模糊时，同步关闭阴影
      return undefined;
    }
    return this.shadowStyle ? this.shadowStyle : !this.isInGroup ? this.itemStyle.shadow : undefined;
  }

  private isEffectEnable(): boolean | undefined {
    if (this.isTempDisableEffect) { // 临时关闭模糊
      return false;
    }
    return this.isNtfCenterGroupItem ? false : this.isUseEffect;
  }

  private isUseColorMode(): boolean { // 是否开启提亮
    // 如果是通知中心并且打开了模糊合并统一提亮配置，此处关闭提亮。
    if (NotificationType.isDropdown(this.notificationType) &&
      this.ntfProductConfig.brightnessMode === NtfBrightnessMode.Centralized &&
      (this.colorModeVM?.isBrightnessEffect || this.ntfEntry?.isLiveType())) {
      return false;
    }

    if (this.isNtfCenterGroupItem) { // 通知中心组通知item不开启
      return false;
    }
    if (this.isTempDisableEffect) { // 临时关闭模糊，同步关闭提亮
      return false;
    }
    // 提亮开关
    return this.isColorModeEnable;
  }

  private getSingleItemContentId(): string {
    if (this.isKeyguardLock && !this.isInGroup) {
      return this.singleItemId + KG_LOCK_SUFFIX;
    }
    return NotificationType.isKeyguard(this.notificationType) ? this.singleItemId + KG_SUFFIX : this.singleItemId;
  }

  private isShowMenu(): boolean {
    if (!this.isDragged) {
      return false;
    }
    return this.canShowMenuRow;
  }

  private ntfOnTouch = (event: TouchEvent): void => {
    if (event.type === TouchType.Move) {
      // 提高触摸按压状态结束的阈值，避免无意识的轻微移动导致按压态结束
      if (this.itemClickScale !== 1 &&
        Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
        Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4) {
        animateTo(NotificationConfig.NOTIFICATION_SCALE_ANIM, () => {
          this.itemClickScale = 1;
        })
      }
      return;
    }

    if (event.type === TouchType.Down) {
      performanceMonitor.begin('NotificationTouchDown',performanceMonitor.ActionType.LAST_UP);
      this.itemClickScale = 0.95;
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;
      return;
    }

    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      performanceMonitor.end('NotificationTouchDown');
      animateTo(NotificationConfig.NOTIFICATION_SCALE_ANIM, () => {
        this.itemClickScale = 1;
      })
      return;
    }
  }

  private onGroupTranslateX = (translateX: number): void => {
    this.groupItemTranX = translateX;
  }

  private isGroupNtfSwipedOpen(): boolean {
    return NotificationUtils.getRTLValue(this.groupItemTranX) < 0;
  }

  private isGestureDisabled(): boolean {
    return this.isGestureDisable;
  }

  private itemClickEvent(): void {
    log.showInfo('on item click: ' + this.ntfEntry?.toSimpleString() + ', ' + this.itemTranX);
    if (NotificationType.isKeyguard(this.notificationType) && !immersiveKgMgr.getImmersiveDisplayState().isList()) {
      log.showInfo(`item click status Inactive ${immersiveKgMgr.getImmersiveDisplayState().immersiveType}`);
      return;
    }
    if (this.isInGroup && this.isGroupNtfSwipedOpen()) {
      this.groupChildNtfDataChannel?.collapseGroupNtf();
      return;
    }
    if (this.isSwipeExpand()) {
      this.swipeController?.swipe2Collapse();
      return;
    }
    if (this.checkShouldClickItem()) {
      // 如果通知消息带按钮，则第一次点击展示按钮，第二次点击进入应用（横幅通知除外）
      return;
    }
    this.itemVm?.onItemClick(this.isHeadsUp, 1, this.isKeyguardLocked(), this.isNtfKeyguard());
  }

  private itemClickEventKg(): void {
    log.showInfo('on item click Kg : ' + this.ntfEntry?.toSimpleString() + ', ' + this.itemTranX);
    if (this.isInGroup && this.isGroupNtfSwipedOpen()) {
      this.groupChildNtfDataChannel?.collapseGroupNtf();
      return;
    }
    if (this.isSwipeExpand()) {
      this.swipeController?.swipe2Collapse();
      return;
    }
    if (this.itemTranX != 0) {
      // 只有当通知没有位移时才允许点击
      return;
    }
    if (this.checkShouldClickItem()) {
      // 如果通知消息带按钮，则第一次点击展示按钮，第二次点击进入应用（横幅通知除外）
      return;
    }

    let isShowButtons = this.ntfEntry?.isLiveType() ? false : !ArrayUtils.isEmpty(this.ntfEntry?.actionButtons);
    let isFbdSingleClk = isShowButtons && (this.displayButtonsHashCode == this.ntfEntry?.hashCode);
    this.itemVm?.onItemClick(this.isHeadsUp, isFbdSingleClk ? 2 : 1, this.isKeyguardLocked(), this.isNtfKeyguard());
  }

  private checkShouldClickItem(clickCount: number = 1): boolean {
    if (this.protectedVm.isProtected(this.ntfEntry?.bundleIdxTag)) {
      return false;
    }

    let result = false;
    // 是否展示按钮：判断按钮列表是否为空
    let isShowButtons = this.checkShowButtons();
    let noNeedCheck = this.isHeadsUp || !isShowButtons;
    if (!noNeedCheck && this.displayButtonsHashCode != this.ntfEntry?.hashCode) {
      result = true;
    }
    // 锁屏场景点击提示处理
    if (result && this.kgDisplayButtonClickTip(clickCount)) {
      return true;
    }

    let notSameEntry = this.displayButtonsHashCode != '' && this.displayButtonsHashCode != this.ntfEntry?.hashCode;
    let firstEntry = this.displayButtonsHashCode == '' && isShowButtons;
    if (notSameEntry || firstEntry) {
      let tarHash = !isShowButtons ? '' : this.ntfEntry?.hashCode ?? '';
      let anim: AnimateParam = {
        curve: BUTTON_DISPLAY_ANIMATION_CURVE,
        onFinish: () => {
          log.showInfo('CheckShouldClickItem on finish [%{public}s] to [%{public}s]', this.displayedNtfHashCode,
            this.displayButtonsHashCode);
          this.displayedNtfHashCode = this.displayButtonsHashCode;
          // 无障碍模式显示按钮需重新聚焦，为了避免多次主动聚焦，需要增加判断，已经主动聚焦过则不执行
          if (this.isAccessibilityMode && !this.hasRequestFocusExpandedCard) {
            AccessibilityUtil.requestFocusAccessibility(this.getSingleItemContentId());
            this.hasRequestFocusExpandedCard = true;
          }
        }
      };
      this.itemActionBtnChange?.(anim); // 按钮动效过渡回调
      animateTo(anim, () => {
        log.showInfo('CheckShouldClickItem on anim %{public}s to empty', this.displayedNtfHashCode);
        this.displayedNtfHashCode = '';
        this.displayButtonsHashCode = tarHash;
      })
    }
    return result;
  }

  private checkShowButtons(): boolean {
    if (this.ntfEntry?.isLiveType() && !this.ntfEntry?.liveViewData?.isLiveSystem()) {
      return false;
    }
    return !ArrayUtils.isEmpty(this.ntfEntry?.actionButtons);
  }

  private itemTwiceClickEvent(): void {
    log.showInfo('on item twice click: ' + this.ntfEntry?.toSimpleString() + ', ' + this.itemTranX);
    if (this.itemTranX != 0) {
      // 只有当通知没有位移时才允许点击
      return;
    }
    if (this.checkShouldClickItem(2)) {
      return;
    }
    this.itemVm?.onItemClick(this.isHeadsUp, 2, this.isKeyguardLocked(), this.isNtfKeyguard());
  }

  private handleActionStart(event? : GestureEvent): void {
    log.showInfo(`onActionStart axisVertical: ${event?.axisVertical}`);
    if (event?.axisVertical && event.axisVertical !== 0) {
      return;
    }
    if (this.displayButtonsHashCode != '') {
      let anim: AnimateParam = { curve: curves.interpolatingSpring(0, 1, 225, 25) };
      this.itemActionBtnChange?.(anim); // 按钮隐藏动效过渡回调
      animateTo(anim, () => {
        this.displayButtonsHashCode = '';
      })
      // 滑动收起按钮后，需要重置hasRequestFocusExpandedCard为false，否则下一次展开时不会自动聚焦
      this.hasRequestFocusExpandedCard = false;
    }
    if (!event || this.swipeHashCode !== '' || this.hasCalledAboutToDisappear) {
      return;
    }
    this.swipeHashCode = this.ntfEntry?.hashCode ?? '';
    this.isRTL = RTLUtil.isRTL();
    Trace.start(Trace.CORE_METHOD_NOTIFICATION_SWIPE + '_' + TAG);
    log.showInfo(`PanGesture onActionStart: ${event.offsetX}`);
    this.swipeController?.onStartSwipe(event);
  }

  private handleActionUpdate(event? : GestureEvent): void {
    if (event?.axisVertical && event.axisVertical !== 0) {
      return;
    }
    if (!event || this.swipeHashCode !== this.ntfEntry?.hashCode) {
      return;
    }
    let isShowEnd = this.isRTL ? event.offsetX > 0 : event.offsetX < 0;
    // 处理按钮显示逻辑
    if (!this.isDragged && isShowEnd) {
      this.isDragged = true;
    }

    this.swipeController?.onUpdateSwipe(event, this.ntfAniParameters);
  }

  private handleActionEnd(event? : GestureEvent): void {
    if (event?.axisVertical && event.axisVertical !== 0) {
      return;
    }
    if (!event || this.swipeHashCode !== this.ntfEntry?.hashCode) {
      return;
    }
    this.swipeHashCode = '';
    log.showInfo(`PanGesture onActionEnd: ${event.offsetX}`);
    this.swipeController?.onEndSwipe(event, NotificationType.isKeyguard(this.notificationType));

    if (DeviceHelper.isPC()) {
      if (!this.getNtfEntry()?.canDelete() && this.isShowMenu()) {
        log.showInfo('PanGesture onActionEnd onUpdateItemTranX to 0');
        this.onUpdateItemTranX(0, false);
      };
    };
    if (this.isShowMenu() && !this.swipeController.isRemoving) {
      AccessUtil.sendNtfSwipeAccessibility(event.offsetX);
    }
    Trace.end(Trace.CORE_METHOD_NOTIFICATION_SWIPE + '_' + TAG);
  }

  private handleActionCancel(): void {
    if (this.swipeHashCode !== this.ntfEntry?.hashCode) {
      return;
    }
    this.swipeHashCode = '';
    this.swipeController?.onCancelSwipe(NotificationType.isKeyguard(this.notificationType));
    Trace.end(Trace.CORE_METHOD_NOTIFICATION_SWIPE + '_' + TAG);
  }

  private getItemClipStyle(): NtfClipAnimStyle {
    if (this.isMediaPlaybackController(this.ntfEntry as NotificationEntry) && this.mediaAnimState.isListGeo) {
      return DEFAULT_CLIP;
    }
    if (this.isInGroup || this.isHeadsUp) {
      return DEFAULT_CLIP;
    }
    let clipHeight = this.itemClipHeight ?? 0;
    let itemWidth = this.slItemWidth?.itemWidth ?? 0;
    if (itemWidth <= 0 || clipHeight <= 0) {
      return DEFAULT_CLIP;
    }
    let absTranX = Math.abs(this.itemTranX);
    if (this.itemTranX < 0) {
      return new NtfClipAnimStyle()
        .buildWidth(itemWidth - absTranX)
        .buildHeight(clipHeight)
        .buildOffsetX(absTranX)
        .buildOffsetY(this.itemClipOffsetY)
        .buildRadius(this.radius ?? 0);
    } else {
      return new NtfClipAnimStyle()
        .buildWidth(itemWidth - absTranX)
        .buildHeight(clipHeight)
        .buildOffsetX(0)
        .buildOffsetY(this.itemClipOffsetY)
        .buildRadius(this.radius ?? 0);
    }
  }

  /**
   * 获取条目圆角
   *
   * @return 圆角
   */
  private getBorderRadius(): BorderRadiuses {
    if (this.overlayAnimData.isAnimating && this.overlayAnimData.bgRadius) {
      return this.overlayAnimData.bgRadius;
    }

    // 非子通知
    if (this.radius && !this.isInGroup) {
      return {
        topLeft: this.radius,
        topRight: this.radius,
        bottomLeft: this.radius,
        bottomRight: this.radius
      }
    }
    // 最后一个子通知，底部圆角
    if (this.getIsLastInGroup()) {
      return {
        topLeft: $r('app.float.ntf_none_vp'),
        topRight: $r('app.float.ntf_none_vp'),
        bottomLeft: this.radius ?? $r('app.float.ntf_list_content_border_radius'),
        bottomRight: this.radius ?? $r('app.float.ntf_list_content_border_radius')
      }
    }
    // 中间条目无圆角
    return {
      topLeft: $r('app.float.ntf_none_vp'),
      topRight: $r('app.float.ntf_none_vp'),
      bottomLeft: $r('app.float.ntf_none_vp'),
      bottomRight: $r('app.float.ntf_none_vp')
    }
  }

  /**
   * 设置隐藏通知内容的状态
   *
   * @return void
   */
  private setNtfHideContentState(newEntry: NotificationEntry) {
    if (CommonUtils.isInvalid(newEntry)) {
      return;
    }
    // 是否隐藏通知内容
    this.isHideNtfContent = newEntry.isHideContent;
    if (newEntry.isLiveType() && newEntry.liveViewData) {
      newEntry.liveViewData.isHideContent = this.isHideNtfContent;
    }
    if (this.isHideNtfContent) {
      if (newEntry.isLiveType()) {
        ResUtils.getInnerPlural($r('app.plural.live_hide_content'), 1).then((result: string) => {
          this.contentHideText = result;
          if (this.ntfEntry?.liveViewData) {
            this.ntfEntry.liveViewData.contentHideText = this.contentHideText;
          }
        });
      } else {
        ResUtils.getInnerPlural($r('app.plural.ntf_hide_content_count'), 1).then((result: string) => {
          this.contentHideText = result;
        });
      }
    }
  }

  /**
   * 新的单通知实例变化回调
   */
  private onNewSingleNft(): void {
    if(this.newSingleNft && (this.ntfEntry?.uid !== this.newSingleNft.uid)) {
      this.onNtfDataUpdate(this.newSingleNft);
    }
  }

  /**
   * 面板触摸事件down点变化
   */
  private onGlobalDownYChange(): void {
    if (!this.isSwipeExpand() || this.panelDownGlobalY === -1) {
      return;
    }
    let itemId = this.getItemId();
    let item: componentUtils.ComponentInfo = ItemUtils.getRectangleById(itemId);
    let globalY = vp2px(this.panelDownGlobalY);

    // 横滑展开状态，down点不在条目区域内，则收起横滑状态
    let itemTop = item.windowOffset.y + this.itemTranslateY;
    let itemBottom = item.size.height + itemTop;

    if (globalY < itemTop || globalY > itemBottom) {
      this.swipeController?.swipe2Collapse();
    }
  }

  /**
   * 面板触摸事件down点X轴坐标变化
   * 针对锁屏通知
   */
  private onGlobalDownXChange(): void {
    if (!this.isSwipeExpand() || this.panelDownGlobalX === -1 ||
      !NotificationType.isKeyguard(this.notificationType)) {
      return;
    }
    let itemId = this.getItemId();
    let item: componentUtils.ComponentInfo = ItemUtils.getRectangleById(itemId);
    let globalX = vp2px(this.panelDownGlobalX);

    // 横滑展开状态，down点不在条目区域内，则收起横滑状态
    let itemLeft = item?.windowOffset?.x;
    let itemRight = (item.size?.width ?? 0) + itemLeft;
    if (globalX > itemRight || globalX < itemLeft) {
      this.swipeController?.swipe2Collapse();
    }
  }

  private getItemId(): string {
    if (this.isKeyguardLock && !this.isInGroup) {
      return this.singleItemId + KG_LOCK_SUFFIX;
    }
    return NotificationType.isKeyguard(this.notificationType) ? this.singleItemId + KG_SUFFIX : this.singleItemId;
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

  /**
   * 当前条目是否swipe展开
   *
   * @return true 展开
   */
  private isSwipeExpand(): boolean {
    return NotificationUtils.getRTLValue(this.itemTranX) < 0;
  }

  private updateItemTranxWithAnim(tranX: number): void {
    if (this.itemTranAnim == null) {
      this.itemTranX = tranX;
    } else {
      log.showInfo(`TranxAnimate_${this.ntfEntry?.hashCode} anim ${util.getHash(this.itemTranAnim)}`);
      animateTo(this.itemTranAnim, () => {
        this.itemTranX = tranX;
      })
    }
  }

  private isMediaPlaybackController(entry: NotificationEntry): boolean {
    if (!entry || entry.liveViewData == undefined) {
      return false;
    }
    let liveViewData: LiveViewData = entry.liveViewData;
    let template: LiveBaseTemplate = liveViewData?.template as LiveBaseTemplate;
    return liveViewData?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  /**
   * 锁屏通知点击发出弹窗提醒
   *
   * @param clickCount 点击计数值, 区分单双击
   * @returns 是否发出弹窗提醒
   */
  private kgDisplayButtonClickTip(clickCount: number): boolean {
    if (!(NotificationType.isKeyguard(this.notificationType) || this.isNtfKeyguard()) || this.isInGroup) {
      // 非锁屏通知或锁屏组通知不做提醒处理
      return false;
    }
    return this.itemVm?.kgDisplayButtonClickTip(clickCount, this.isKeyguardLocked(),
      this.isHideNtfContent, this.isNtfKeyguard());
  }

  private onLockStateChange() {
    if ((this.isKeyguardLock || bannerMgr.isSupportDouble(this.isNeedPanelInScreenLock, this.isLockScreen
      , this.isSecureAndLocked)) && !this.isInGroup) {
      this.itemGestureModifier.isSupportDouble = true;
    } else {
      this.itemGestureModifier.isSupportDouble = false;
    }
  }

  private initItemGestureModifier() {
    this.itemGestureModifier.callback = {
      handleDoubleTwiceClick: () => this.itemTwiceClickEvent(),
      handleDoubleOnceClick: () => this.itemClickEventKg(),
      handleSingleClick: () => this.itemClickEvent()
    };
    this.onLockStateChange();
  }

  private deinitItemGestureModifier() {
    this.itemGestureModifier.callback = undefined;
  }

  private getTextTranAnimParam(): TransitionEffect | undefined {
    if (!this.isDropDownAniFin && !this.isInGroup) {
      return undefined;
    }
    if (DeviceHelper.isPC()) {
      return TransitionEffect.IDENTITY
    }
    return TransitionEffect.asymmetric( this.isClicked ?
      TransitionEffect.translate({ y: -30 })
        .animation({ duration: 333, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
        TransitionEffect.OPACITY.animation({
          delay: 60,
          duration: 333,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
        })
      ) : TransitionEffect.IDENTITY,
      this.isClicked ? TransitionEffect.translate({ y: -30 })
        .animation({ duration: 333, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
        TransitionEffect.OPACITY.animation({
          duration: 200,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
        })
      ) : TransitionEffect.OPACITY.animation({
        duration: 200,
        curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
      })
    );
  }

  private isKeyguardLocked() {
    return this.isKeyguardLock || this.isSecureAndLocked;
  }

  private isNtfKeyguard() {
    return this.isNeedPanelInScreenLock && this.isLockScreen;
  }

  private getScale(): number {
    if (DeviceHelper.isPC()) {
      return this.itemClickScale * this.hoverScaleRate;
    }
    if (!this.isInGroup) {
      this.setClipParam();
    }
    return this.itemClickScale;
  }

  private setClipParam(): void {
    if (!NotificationType.isDropdown(this.notificationType)) {
      this.itemClipParam = true;
      return;
    }
    // 缩小
    const isSlimDown = this.itemClickScale < 1;
    if (this.ntfAniParameters && this.radius) {
      this.itemClipParam = this.ntfScrollAnimation.getClipParam(this.ntfAniParameters,
        this.ntfEntry, sDropDownPanelManager.isClearAll, this.radius, isSlimDown);
    }
  }
}
