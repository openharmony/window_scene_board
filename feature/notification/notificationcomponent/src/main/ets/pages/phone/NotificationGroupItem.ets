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

import { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationMenuRow } from '../common/NotificationMenuRow';
import { NtfHeaderVM } from '../../vm/NtfHeaderVM';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import {
  ArrayUtils,
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  RectInfo,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import {
  DeviceHelper,
  EventManager,
  EvtBus,
  obtainLocalEvent,
  sEventManager,
  unsubscribe
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  GroupItemExpandingEvent,
  NtfListScrollEvent,
  NtfSwipeDeleteEvent,
  ResetItemSwipeEvent
} from '../../common/event/NotificationEvent';
import { NotificationConstants } from '../../common/NotificationConstants';
import GroupChildNtfDataChannel from '../../vm/GroupChildNtfDataChannel';
import { NotificationGroupBrief } from './NotificationGroupBrief';
import curves from '@ohos.curves';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import { NotificationGroupDetail } from './NotificationGroupDetail';
import {
  AccessibilityUtil,
  bannerMgr,
  NotificationSysEventReporter
} from '@ohos/systemuicommon';
import { NotificationType } from '../../common/NotificationType';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon/src/main/ets/constants/ScreenLockNotificationConstants';
import { NotificationAnimationParas } from '../../common/NotificationAnimationParas';
import { NotificationConfig } from '../../common/NotificationConfig';
import { screenLockSysFloatTipControl } from '@ohos/screenlockcommon/src/main/ets/manager/SysFloatTipController';
import { NotificationItemStyle } from '../../vm/style/NotificationItemStyle';
import { SlNtfItemWidth } from '../../common/SlNtfItemWidth';
import { DEFAULT_CLIP, NtfClipAnimStyle } from '../../common/NtfClipAnimStyle';
import { NtfAnimVM } from '../../vm/NtfAnimVM';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { ItemGestureModifier } from '../../model/NotificationGestureModifier';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import {
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { NotificationUtils } from '../../common/NotificationUtils';
import { NotificationAccessibilityUtil as AccessUtil } from '../../common/NotificationAccessibilityUtil';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NtfBrightnessMode, NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import { BrightnessOptionUtils, OverlayAnimData } from '@ohos/systemuicommon/Index';
import { GroupItemAreaModifier, NtfGroupItemModifier } from '../../model/NtfItemModifier';
import { NtfScrollAnimation } from '../../animation/NtfScrollAnimation';
import { NotificationGroupExpandAnimation } from '../../animation/NotificationGroupExpandAnimation';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICommonUtil';
import { ActionInterceptor, ActionInterceptorManager } from '../../manager/ActionInterceptorManager';
import { SINGLE_APP_LIMIT } from '../../model/NotificationListLimiter';
import { NtfSingleItemVM } from '../../vm/NtfSingleItemVM';

const TAG = 'NotificationGroupItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * 分组前两条通知数
 */
const GROUP_PRE_TWICE = 3;

/**
 * 一组最多显示通知数
 */
const GROUP_MAX_SHOW_SIZE = 8;

const ANIM_KG_DELAY = 25;
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
    }) : false)
}

/**
 * 通知分组
 *
 * @since 2022-12-22
 */
@Component
export struct NotificationGroupItem {
  /**
   * 分组通知数据
   * 分组通知对象一般不会变
   */
  private ntfEntry?: NotificationEntry;

  /**
   * 组通知展开变化回调
   */
  private changeItemExpand?: (isExpand: boolean) => void;

  /**
   * 通知列表类型
   */
  @Consume notificationType: number;

  @StorageLink('contract') @Watch('contractEvent') contract: boolean = false;

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

  // 叠加动效参数
  @ObjectLink ntfAniParameters: NotificationAnimationParas;

  /**
   * 通知列表滑动动效
   */
  private ntfScrollAnimation: NtfScrollAnimation = new NtfScrollAnimation();

  /**
   * 叠加缩放参数
   */
  @Prop outScale: number;

  /**
   * 当前分组是否展开
   */
  @State @Watch('onIsGroupExpandedChange') isGroupExpanded: boolean = false;

  /**
   * 触摸动效scale参数
   */
  @State groupItemScale: number = 1;

  /**
   * 分组通知个数
   */
  @Provide groupRemainderCount: string = '';

  /**
   * 隐藏通知内容时，几个通知
   */
  @Provide groupCountHideText: string = ' ';

  /**
   * 是否隐藏通知内容
   */
  @Provide isHideNtfContent: boolean = false;

  /**
   * 组通知横滑平移距离，共享给子组件判断组通知是否展开状态
   */
  @State groupItemTranX: number = 0;

  /**
   * 组通知透明度
   */
  @State groupContentOpacity: number = 1;

  /**
   * 分组子通知列表
   */
  @State ntfChildrenList: Array<NotificationEntry> = [];

  /**
   * 圆角
   */
  @Prop radius: number = 0;

  /**
   * 组通知横滑动画
   */
  private groupItemTranAnim: AnimateParam | null = null;

  /**
   * 组通知最后一个Item的hash code，用于判断是否是最后一个item。
   */
  @State lastItemHashCode: string = '';
  /**
   * 组通知第一个item的hash code
   */
  @State firstItemHashCode: string = '';
  /**
   * 通知是否点击展开
   */
  @State isClicked: boolean = false;
  /**
   * 分组头数据VM
   */
  private headerVM: NtfHeaderVM = new NtfHeaderVM();

  /**
   * 组通知条目横滑控制器
   */
  private swipeController: NtfItemSwipeController = new NtfItemSwipeController();

  /**
   * close按钮VM
   */
  @Consume private closeVM?: NtfCloseVM;

  @State groupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier(this.closeVM);

  @State groupItemAreaModifier: GroupItemAreaModifier = new GroupItemAreaModifier(this.ntfAniParameters);

  @State hoverScaleRate: number = 1;

  private touchStartX: number = 0;
  private touchStartY: number = 0;

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private singleItemVm: NtfSingleItemVM = new NtfSingleItemVM();

  /**
   * 组通知GroupBrief的高度
   */
  static briefHeight: number = 0;

  /**
   * 组通知与子通知数据交换
   */
  private groupChildDataChannel: GroupChildNtfDataChannel | null = null;

  /**
   * the width of menu
   */
  private menuWidth: number = 0;

  /**
   * 锁屏左滑菜单的宽度
   */
  @State slMenuWidth: number = 0;

  /**
   * the height of menu
   */
  private menuClipHeight: number = 0;

  private isUseEffect: boolean = false;

  /**
   * 订阅函数列表
   */
  private unsubscribeFuncArr: Array<unsubscribe> = [];

  private deleteAnimSyncFlag: boolean = false;

  private deleteAnimSyncData: NotificationEntry | undefined;

  @Prop canExpand: boolean = true;

  @Prop isGestureEnabled: boolean = true;

  /**
   * 简介图标距离顶部的位置
   */
  @State briefIconPositionY: number = 0;

  /**
   * 是否显示通知时间
   */
  private showDateTime: boolean = true;

  /**
   * 记录左滑状态的通知的哈希值，用于左滑状态互斥（同一时刻，只允许一条通知左滑）
   */
  @Consume @Watch('onSwipeIdChange') swipeHashCode: string;

  /**
   * 记录通知是否被拖动过，用于控制menu加载
   */
  @State isDragged: boolean = false;

  @Prop itemTranslateY: number = 0;

  private hasCalledAboutToDisappear: boolean = false;
  /**
   * 记录展示按钮的通知的哈希值，用于互斥操作
   */
  @Consume displayButtonsHashCode: string;

  /**
   * 锁屏是否加锁状态
   */
  @Consume @Watch('onLockStateChange') isKeyguardLock: boolean;

  /**
   * 锁屏条目宽度记录
   */
  @State slItemWidth?: SlNtfItemWidth = undefined;

  /**
   * 通知条目样式
   */
  @State itemStyle: NotificationItemStyle = notificationStyle.item;

  /**
   * 通知动效vm
   */
  ntfAnimVM: NtfAnimVM | undefined = undefined;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;
  /**
   * 裁剪参数
   */
  @State clipParam: boolean | RectAttribute = true;
  /**
   * 叠加缩放中心
   */
  @Prop outScaleCenterY: string | number = '50%';

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  @State itemGestureModifier: ItemGestureModifier = new ItemGestureModifier();

  private dataChangeInterrupt?: PromiseInterrupt = undefined;

  private isRTL: boolean = RTLUtil.isRTL();

  private groupItemArea: Area | undefined = undefined;

  /**
   * 通知数据是否在更新
   */
  private isDataUpdate: boolean = false;
  /**
   * 当前通知条目可以显示左滑按钮
   */
  private canShowMenuRow: boolean = false;

  private ntfProductConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();
  private isBrightModeCentralized: boolean = (this.ntfProductConfig.brightnessMode === NtfBrightnessMode.Centralized);
  @State @Watch('onOverlayAnimDataChanged') overlayAnimData: OverlayAnimData = new OverlayAnimData();
  private ancestorsOverlayAnimData?: OverlayAnimData[];

  @Prop @Watch('onLockStateChange') isNeedPanelInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop @Watch('onLockStateChange') isLockScreen: boolean = false;
  @Prop @Watch('onLockStateChange') isSecureAndLocked: boolean = false;

  private updateDataInterceptor?: ActionInterceptor;
  private scrollUpIfNeed = (groupTypeKey?: string): void => {};

  onSwipeIdChange() {
    log.showDebug(`onSwipeIdChange:${this.ntfEntry?.getGroupKey()}, ${this.swipeHashCode}}`);
    if (this.ntfEntry?.getGroupKey() !== this.swipeHashCode && this.swipeHashCode !== '' &&
      !this.swipeController.isRemoving) {
      this.onUpdateItemTranX(0, false);
    }
  }

  onIsGroupExpandedChange() {
    this.updateDisplayButtonsHashCode();
    if (this.changeItemExpand) {
      this.changeItemExpand(this.isGroupExpanded);
    }
    this.ntfAniParameters?.updateGroupExpanded(this.isGroupExpanded);
    const groupItemId = NotificationConstants.getGroupNTFItemCompId(this.ntfEntry?.getGroupTypeKey()!);
    const groupBriefId = NotificationConstants.getGroupBriefItemCompId(this.ntfEntry?.getGroupTypeKey()!);
    const cardItemId = this.isGroupExpanded ? groupItemId : groupBriefId;
    const cardRect: RectInfo = ItemUtils.getRectById(cardItemId);
    if (cardRect.bottom >= NtfScrollAnimation.listRect.bottom && this.ntfAniParameters) {
      this.ntfAniParameters.isBottomItem = true;
    }
  }

  onOverlayAnimDataChanged(): void {
    log.showInfo('onOverlayAnimDataChanged to %{public}s', this.overlayAnimData.toStr());
    if (this.overlayAnimData.isAnimating) {
      this.clipParam = false;
    }
  }

  static getBriefHeight(): number {
    return NotificationGroupItem.briefHeight;
  }

  static setBriefHeight(height: number): void {
    if (height != NotificationGroupItem.briefHeight && height != 0) {
      NotificationGroupItem.briefHeight = height;
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.overlayAnimData.setTag(`${TAG}_${this.ntfEntry?.getGroupTypeKey()}`);
    // 恢复默认展开状态
    this.isGroupExpanded = this.ntfEntry?.isItemExpanded ?? false;
    // 初始化组通知个数
    this.refreshGroupCount();
    // 初始化子通知列表
    this.refreshChildrenList();
    this.refreshMenuRowStatus(this.ntfEntry);
    // 注册数据刷新
    this.ntfEntry?.registerDataUpdateListener(this);
    // 注册横滑监听
    this.swipeController?.setNtfEntry(this.ntfEntry as NotificationEntry);
    this.swipeController?.registerSwipeCallback(this);
    this.eventMgr.on(ResetItemSwipeEvent, this.onCloseSwipeEvent)
    this.eventMgr.on(NtfSwipeDeleteEvent, this.onNtfSwipeDeleteEvent);
    this.eventMgr.on(NtfListScrollEvent, this.onNtfListScrollEvent);
    this.groupChildDataChannel = new GroupChildNtfDataChannel();
    this.groupChildDataChannel.setGroupCollapseCallback(this.collapseGroupNtf);
    log.showDebug(`NotificationGroupItem aboutToAppear`);
    this.unsubscribeFuncArr.push(sEventManager.subscribe(NotificationConstants.ntfFoldGroupItem, (value: boolean) => {
      log.showDebug(`ntfFoldGroupItem`);
      if (value) {
        this.isGroupExpanded = false;
      } else {
        // 裁切动效曲线保持一致
        this.ntfAniParameters?.updateClipAnim({
          duration: NotificationGroupExpandAnimation.duration,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
        })
          .setClipAnimWait().updateItemPresSize();
        animateTo({
          duration: NotificationGroupExpandAnimation.duration,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
          onFinish: () => {
            log.showDebug('ntfFoldGroupItem ani_finish');
          }
        }, () => {
          this.isGroupExpanded = false;
        });
      }
      (this.ntfEntry as NotificationEntry).isItemExpanded = this.isGroupExpanded;
      this.headerVM.setItemExpandState(this.isGroupExpanded);
    }));

    if (NotificationType.isKeyguard(this.notificationType)) {
      this.slItemWidth = this.swipeController?.getSlItemWidth();
      this.unsubscribeFuncArr.push(sEventManager.subscribe(
        ScreenLockNotificationConst.SCREENLOCK_NTF_NEED_TO_SWIPE_TO_COLLAPSE,
        (forceReset: boolean) => {
          if (!this.isSwipeExpand()) {
            return;
          }
          this.swipeController?.swipe2Collapse();
          if (forceReset) {
            this.groupItemTranX = 0;
          }
        }));
    }
    this.initItemGestureModifier();
    this.groupItemModifier.setEntry(this.ntfEntry);
    this.updateDataInterceptor =
      ActionInterceptorManager.instance.getInterceptor(NotificationConstants.UPDATE_DATA_INTERCEPTOR);
    this.singleItemVm.init(this);
  }

  onCloseSwipeEvent = (event: ResetItemSwipeEvent) => {
    if (CommonUtils.isInvalid(this.ntfEntry) || CommonUtils.isInvalid(event)) {
      return;
    }
    if (this.ntfEntry && this.ntfEntry.isGroup && event?.ntfGroupKey === this.ntfEntry.getGroupKey()) {
      this.swipeController?.swipe2Collapse();
    }
  }
  private onNtfListScrollEvent = (): void => {
    if (this.outScale >= 1 && this.isGroupExpanded && typeof this.clipParam !== 'boolean') {
      //Y轴滚动时需要更新裁剪参数，防止上移组通知时仍然有截断
      this.clipParam = true;
    }

    if (this.groupItemTranX === 0) {
      return;
    }
    this.swipeController?.swipe2Collapse();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.hasCalledAboutToDisappear = true;
    this.eventMgr.offAll();
    this.unsubscribeFuncArr.forEach((func) => func());
    // 清空缓存
    if (this.ntfEntry) {
      this.ntfEntry?.unregisterDataUpdateListener(this);
      this.swipeController?.unregisterSwipeCallback(this);
      this.groupChildDataChannel?.destroyCallbacks();
      log.showDebug(`NotificationGroupItem aboutToDisappear:${this.ntfEntry.toSimpleString()}`);
    }
    this.closeVM?.setItemTranslate(0);
    this.refreshSwipeHashCode();
    this.deinitItemGestureModifier();
  }

  refreshSwipeHashCode(): void {
    if (this.isKeyguardLock && this.swipeHashCode != '' && this.ntfEntry?.getGroupKey() === this.swipeHashCode) {
      log.showInfo(`about to disappear, reset own swipeHashCode`);
      this.swipeHashCode = '';
    }
  }

  onUpdateItemOpacity(opacity: number): void {
    this.groupContentOpacity = opacity
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
    // 通知子通知组件组通知平移
    this.groupChildDataChannel?.groupTranslateXChanged(tranX);
    // 无障碍下，移除组通知播报语音
    AccessUtil.sendNtfRemoveAccessibility(isRemoveEntry);
  }

  /**
   * 更新通知条目横向平移动画
   * SwipeCallback
   *
   * @param itemAnim 动画
   */
  onUpdateItemAnim(itemAnim: AnimateParam): void {
    this.groupItemTranAnim = itemAnim;
  }

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  async onNtfDataUpdate(newEntry: NotificationEntry): Promise<void> {
    log.showInfo(`notification group update ${this.deleteAnimSyncFlag}`);
    if (this.deleteAnimSyncFlag) {
      log.showDebug(`deleteAnimaSync pause`);
      this.deleteAnimSyncData = newEntry;
      return;
    }
    // 数据刷新拦截等待
    await this.dataChangeInterrupt?.awaitInterrupt();
    await this.updateDataInterceptor?.awaitInterrupt();
    this.ntfEntry = newEntry;
    this.groupItemModifier?.setEntry(this.ntfEntry);
    this.swipeController?.setNtfEntry(newEntry);
    // 刷新通知个数
    this.refreshGroupCount();
    // 刷新子通知列表
    this.refreshChildrenList();
    this.refreshMenuRowStatus(newEntry);
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
    const isNeedSetting =
      ntfEntry.canShowSetting(this.notificationType, false, ntfViewConfigManager.getListContentConfig().isOuterHome);
    this.canShowMenuRow = canDel || isNeedSetting;
  }

  /**
   * 获取当前通知卡片的无障碍描述文本
   * @returns
   */
  private getAccessibilityDescription(): string {
    if (this.canShowMenuRow) {
      return AccessUtil.getSwipeDescription(this.isAccessibilityMode, this.groupItemTranX !== 0);
    }
    return '';
  }

  @Builder
  kgLockNtfGroupBrief() {
    Stack() {
      NotificationGroupBrief({
        ntfEntry: this.ntfEntry,
        colorModeVM: this.colorModeVM,
        showDateTime: this.showDateTime,
        isClicked: this.isClicked,
        radius: this.radius,
        dataChangeInterrupt: this.dataChangeInterrupt,
        animHeightChange: (animParam) => {
          // 缓存裁剪动效，标记裁切动效等待
          this.ntfAniParameters?.updateClipAnim(animParam)
            .setClipAnimWait().updateItemPresSize();
        },
        briefIconPositionY: this.briefIconPositionY
      })
    }
    .id(TAG + '_GroupBrief_' + this.ntfEntry?.getGroupTypeKey())
    // 无障碍场景双击响应click
    .onClick(this.isKeyguardLock ? undefined : (this.canExpand ? (this.isHideNtfContent ? undefined :
      (this.isAccessibilityMode ? () => { this.onGroupBriefClick(2); } : undefined)) : undefined))
    .onGestureJudgeBegin((info) => {
      return this.swipeController?.onGestureJudgeBegin(this.notificationType, info);
    })
    .gestureModifier(this.itemGestureModifier)
  }

  @Builder
  buildKgLockNtfGroupDetail() {
    NotificationGroupDetail({
      ntfEntry: this.ntfEntry,
      colorModeVM: this.colorModeVM,
      isGroupExpanded: this.isGroupExpanded,
      ntfChildrenList: this.ntfChildrenList,
      isUseEffect: this.isUseEffect,
      isClicked: this.isClicked,
      radius: this.radius,
      headerVM: this.headerVM,
      groupChildDataChannel: this.groupChildDataChannel,
      lastItemHashCode: this.lastItemHashCode,
      firstItemHashCode: this.firstItemHashCode,
      groupItemTranX: this.groupItemTranX,
      swipeController: this.swipeController,
      isColorModeEnable: true, // 开启组通知整体背景提亮
      animCollapse: (animParam) => {
        // 缓存裁剪动效，标记裁切动效等待
        this.ntfAniParameters?.updateClipAnim(animParam)
          .setClipAnimWait().updateItemPresSize(true);
      },
      overlayAnimData: this.overlayAnimData,
      briefIconPositionY: this.briefIconPositionY,
      ntfAniParameters: this.ntfAniParameters,
    })
      .id(NotificationConstants.getGroupNTFItemCompId(this.ntfEntry?.getGroupTypeKey()!))
  }

  @Builder
  buildKeyguardGroupItem() {
    // 内层NotificationGroupBrief中用到的backgroundBrightnessInternal接口需要在useEffect后的更深一级使用;
    // 使用clip的扩展动效，需要和useEffect在同级使用，并且只能用在基础布局上。所以套一层
    Column() {
      Column() {
        if (this.isGroupExpanded) {
          this.buildKgLockNtfGroupDetail();
        } else {
          this.kgLockNtfGroupBrief();
        }
      }
      .clip(true)
      .borderRadius(this.radius)
      .backgroundColor(this.colorModeVM?.themeBgColor)
      .backgroundBrightnessInternal(this.colorModeVM?.themeBgBrightnessOption)
    }
    .scale({ x: this.getScale(), y: this.getScale(), centerX: '50%',
      centerY: this.ntfAniParameters?.itemScaleCenterY})
    .useEffect(this.isUseEffect)
    .shadow(this.itemStyle.shadow) // 阴影、裁切保持同步
    .itemClip(this.getItemClipStyle())
    .borderRadius(this.radius)
    .onAppear(() => {
      if (this.isKeyguardLock) {
        sEventManager.publish(obtainLocalEvent(NotificationConstants.PHONE_LOCK_IS_GROUP_EXPANDED,
          this.isGroupExpanded));
      }
    })
    .translate({ x: this.groupItemTranX })
    .opacity(this.groupContentOpacity)
    .hitTestBehavior(HitTestMode.Transparent)
    .onSizeChange((oldArea: SizeOptions, newArea: SizeOptions) => {
      if (oldArea?.width !== newArea?.width) {
        this.swipeController?.setItemWidth(newArea.width as number);
      }
    })
    .pointLight({
      illuminated: NotificationType.isKeyguard(this.notificationType) ?
      IlluminatedType.BORDER : IlluminatedType.NONE
    })
  }

  @Builder
  buildColumn() {
    if (this.isGroupExpanded) {
      NotificationGroupDetail({
        ntfEntry: this.ntfEntry,
        colorModeVM: this.colorModeVM,
        isGroupExpanded: this.isGroupExpanded,
        ntfChildrenList: this.ntfChildrenList,
        ntfAnimVM: this.ntfAnimVM,
        isUseEffect: this.isUseEffect,
        isClicked: this.isClicked,
        radius: this.radius,
        headerVM: this.headerVM,
        groupChildDataChannel: this.groupChildDataChannel,
        lastItemHashCode: this.lastItemHashCode,
        firstItemHashCode: this.firstItemHashCode,
        groupItemTranX: this.groupItemTranX,
        swipeController: this.swipeController,
        isNtfCenterGroupItem: true,
        overlayAnimData: this.overlayAnimData,
        ancestorsOverlayAnimData: this.ancestorsOverlayAnimData,
        briefIconPositionY: this.briefIconPositionY,
        isNeedPanelInScreenLock: this.isNeedPanelInScreenLock,
        isLockScreen: this.isLockScreen,
        isSecureAndLocked: this.isSecureAndLocked,
        ntfAniParameters: this.ntfAniParameters,
      })
        .id(NotificationConstants.getGroupNTFItemCompId(this.ntfEntry?.getGroupTypeKey()!))
        .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentWidth : undefined)
        .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentHeight : undefined)
        .opacity(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentOpacity : undefined)
        .onAppear(() => { sEventManager.publish(obtainLocalEvent(
            NotificationConstants.PHONE_LOCK_IS_GROUP_EXPANDED, this.isGroupExpanded));
        })
    } else {
      NotificationGroupBrief({
        ntfEntry: this.ntfEntry,
        colorModeVM: this.colorModeVM,
        showDateTime: this.showDateTime,
        isClicked: this.isClicked,
        radius: this.radius,
        briefIconPositionY: this.briefIconPositionY
      })
        .id(TAG + '_GroupBrief_' + this.ntfEntry?.getGroupTypeKey())
        .onClick(this.getClickEvent())
        .accessibilityDescription(this.getAccessibilityDescription())
        .opacity(this.ntfChildrenList.length > 1 ? 1 : 0)
    }
  }

  @Builder
  buildColumnWhenIsNtfKeyguard() {
    if (this.isGroupExpanded) {
      NotificationGroupDetail({
        ntfEntry: this.ntfEntry,
        colorModeVM: this.colorModeVM,
        isGroupExpanded: this.isGroupExpanded,
        ntfChildrenList: this.ntfChildrenList,
        ntfAnimVM: this.ntfAnimVM,
        isUseEffect: this.isUseEffect,
        isClicked: this.isClicked,
        radius: this.radius,
        headerVM: this.headerVM,
        groupChildDataChannel: this.groupChildDataChannel,
        lastItemHashCode: this.lastItemHashCode,
        firstItemHashCode: this.firstItemHashCode,
        groupItemTranX: this.groupItemTranX,
        swipeController: this.swipeController,
        isNtfCenterGroupItem: true,
        overlayAnimData: this.overlayAnimData,
        ancestorsOverlayAnimData: this.ancestorsOverlayAnimData,
        briefIconPositionY: this.briefIconPositionY,
        isNeedPanelInScreenLock: this.isNeedPanelInScreenLock,
        isLockScreen: this.isLockScreen,
        isSecureAndLocked: this.isSecureAndLocked,
        ntfAniParameters: this.ntfAniParameters,
      })
        .id(NotificationConstants.getGroupNTFItemCompId(this.ntfEntry?.getGroupTypeKey()!))
        .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentWidth : undefined)
        .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentHeight : undefined)
        .opacity(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentOpacity : undefined)
        .onAppear(() => { sEventManager.publish(obtainLocalEvent(
          NotificationConstants.PHONE_LOCK_IS_GROUP_EXPANDED, this.isGroupExpanded));
        })
    } else {
      this.buildNotificationGroupBriefKeyguard();
    }
  }

  private getClickEvent(): (() => void) | undefined {
    if (!this.canExpand) {
      return undefined;
    }
    if (this.isHideNtfContent) {
      return undefined;
    }
    return () => {
      this.onGroupBriefClick(2);
    }
  }

  @Builder
  buildNotificationGroupBriefKeyguard() {
    Stack() {
      NotificationGroupBrief({
        ntfEntry: this.ntfEntry,
        colorModeVM: this.colorModeVM,
        showDateTime: this.showDateTime,
        isClicked: this.isClicked,
        radius: this.radius,
        briefIconPositionY: this.briefIconPositionY
      })
    }
    .id(TAG + '_GroupBrief_' + this.ntfEntry?.getGroupTypeKey())
    .onClick(this.isAccessibilityMode ? this.getClickEvent() : undefined)
    .gestureModifier(this.itemGestureModifier)
    .accessibilityDescription(AccessUtil.getSwipeDescription(this.isAccessibilityMode, this.groupItemTranX !== 0))
  }

  @Builder
  buildGroupItem() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        if (!this.isNtfKeyguard()) {
          this.buildColumn();
        } else {
          this.buildColumnWhenIsNtfKeyguard();
        }
      }
      .backgroundColor(this.isBrightModeCentralized && this.colorModeVM?.isBrightnessEffect ? undefined :
        this.colorModeVM?.themeBgColor)
      .backgroundBrightnessInternal(this.isBrightModeCentralized ? undefined : this.colorModeVM?.themeBgBrightnessOption)
      .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.bgWidth : undefined)
      .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.bgHeight : undefined)
      .borderRadius(this.overlayAnimData.isAnimating ? this.overlayAnimData.bgRadius : undefined)
      .justifyContent(FlexAlign.Center)
    }
    .useEffect(this.isUseEffect)
    .shadow(this.itemStyle.shadow)
    .scale({
      x: this.getScale(),
      y: this.outScale * this.groupItemScale,
      centerX: '50%',
      centerY: this.outScale < 1 && NotificationType.isDropdown(this.notificationType) ?
      this.outScaleCenterY : this.ntfAniParameters?.itemScaleCenterY
    })
    .borderRadius(this.overlayAnimData.isAnimating ? this.overlayAnimData.bgRadius : this.radius)
    .clip(this.clipParam)
    .translate({ x: this.groupItemTranX, y: this.overlayAnimData.isAnimating ? this.overlayAnimData.transY : 0 })
    .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentWidth : undefined)
    .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentHeight : undefined)
    .opacity(this.groupContentOpacity)
    .hitTestBehavior(HitTestMode.Transparent)
    .onSizeChange((oldArea: SizeOptions, newArea: SizeOptions) => {
      if (oldArea?.width === newArea?.width) {
        return;
      }
      // 设置条目宽度
      this.swipeController?.setItemWidth(newArea.width as number);
    })
    .attributeModifier(this.groupItemAreaModifier)
  }

  build() {
    Stack({ alignContent: this.getAlignment() }) {
      if (this.isKeyguardLock || NotificationType.isKeyguard(this.notificationType)) {
        this.buildKeyguardGroupItem();
      } else {
        this.buildGroupItem()
      }

      // 左滑menu按钮
      if (this.isDragged && this.canShowMenuRow) {
        NotificationMenuRow({
          ntfEntry: this.ntfEntry,
          swipeController: this.swipeController,
          colorModeVM: this.colorModeVM
        })
          .margin({ top: (this.isGroupExpanded ? $r('app.float.ntf_item_padding_start_end') : undefined) })
          .onSizeChange((oldValue: SizeOptions, newArea: SizeOptions) => {
            this.menuWidth = newArea?.width as number ?? 0;
            this.slMenuWidth = newArea?.width as number ?? 0;
            this.menuClipHeight = (newArea?.height as number ?? 0) +
              (this.isGroupExpanded ? NotificationConstants.NTF_MENU_ROW_MARGIN_TOP : 0);
          })
          .clip(this.ntfMenuRowClip())
          .scale({ x: this.groupItemScale, y: this.groupItemScale })
          .width(this.groupItemTranX === 0 ? 0 : undefined)
          .zIndex(-1)
      }
    }
    .onDisAppear(() => {
      log.showInfo(`onDisAppear`);
      this.closeVM?.cancelItemHover(this.ntfEntry!);
    })
    .scale({x: this.hoverScaleRate, y: this.hoverScaleRate})
    .animation({duration: 300, curve: Curve.Sharp})
    .accessibilityLevel('no')
    .onTouch(this.ntfOnTouch)
    .visibility(this.closeVM?.deletingItem === this.ntfEntry
      && !DeviceHelper.isPC() ? Visibility.Hidden : Visibility.Visible)
    .width('100%')
    .borderRadius(this.radius)
    .clip(this.overlayAnimData.isAnimating ? false : NotificationType.isPc(this.notificationType) ? true :
    (!this.itemStyle.shadow || (!this.isKeyguardLock && NotificationType.isDropdown(this.notificationType))))
    // 当swipe展开时，点击收起swipe
    .onClick(this.isSwipeExpand() ? () => {
      this.swipeController?.swipe2Collapse();
    } : () => {})
    .onGestureJudgeBegin((info) => {
      return this.swipeController?.onGestureJudgeBegin(this.notificationType, info);
    })
    // 横滑手势
    .gesture(GestureGroup(
      GestureMode.Parallel,
      // 横滑触摸手势
      PanGesture({ direction: PanDirection.Horizontal, distance: NtfItemSwipeController.SWIPE_DISTANCE })
        .onActionStart((event) => {
          log.showInfo(`onActionStart axisVertical: ${event?.axisVertical}`);
          if (event?.axisVertical && event.axisVertical !== 0) {
            return;
          }
          this.updateDisplayButtonsHashCode();
          if (!this.isGestureEnabled) {
            return;
          }
          if (!event || this.swipeHashCode !== '' || this.hasCalledAboutToDisappear) {
            return;
          }
          this.isRTL = RTLUtil.isRTL();
          Trace.start(Trace.CORE_METHOD_NOTIFICATION_SWIPE);
          this.swipeHashCode = this.ntfEntry?.getGroupKey();
          this.swipeController?.onStartSwipe(event);
        })
        .onActionUpdate((event) => {
          if (event?.axisVertical && event.axisVertical !== 0) {
            return;
          }
          if (!this.isGestureEnabled) {
            return;
          }
          if (!event || this.swipeHashCode !== this.ntfEntry?.getGroupKey()) {
            return;
          }
          let isShowEnd = this.isRTL ? event.offsetX > 0 : event.offsetX < 0;
          if (isShowEnd && !this.isDragged) {
            this.isDragged = true;
          }
          this.swipeController?.onUpdateSwipe(event, this.ntfAniParameters);
        })
        .onActionEnd((event) => {
          if (event?.axisVertical && event.axisVertical !== 0) {
            return;
          }
          if (!this.isGestureEnabled) {
            return;
          }
          if (!event || this.swipeHashCode !== this.ntfEntry?.getGroupKey()) {
            return;
          }
          this.swipeHashCode = '';
          this.swipeController?.onEndSwipe(event, NotificationType.isKeyguard(this.notificationType));
          if (this.canShowMenuRow && this.isDragged && !this.swipeController.isRemoving) {
            AccessUtil.sendNtfSwipeAccessibility(event.offsetX);
          }
          Trace.end(Trace.CORE_METHOD_NOTIFICATION_SWIPE);
        })
        .onActionCancel(() => {
          if (!this.isGestureEnabled) {
            return;
          }
          if (this.swipeHashCode !== this.ntfEntry?.getGroupKey()) {
            return;
          }
          this.swipeHashCode = '';
          this.swipeController?.onCancelSwipe(NotificationType.isKeyguard(this.notificationType));
          Trace.end(Trace.CORE_METHOD_NOTIFICATION_SWIPE);
        })
    ))
    .id(TAG + '_GroupItem_' + this.ntfEntry?.getGroupTypeKey() + this.notificationType)
    .onHover((isHover: boolean) => {
      this.hoverScaleRate = (isHover && DeviceHelper.isPC()) ? 1.02 : 1;
    })
  }

  /**
   * 通知左滑菜单裁剪
   *
   * @return PathAttribute | RectAttribute | boolean 裁剪形状
   */
  private ntfMenuRowClip(): PathAttribute | RectAttribute | boolean {
    let marginTopVal = this.isGroupExpanded ? NotificationConstants.NTF_MENU_ROW_MARGIN_TOP : 0;
    return NotificationType.isKeyguard(this.notificationType) ?
    this.swipeController?.buildKgMenuClipRect({
      menuWidth: this.slMenuWidth,
      menuHeight: this.menuClipHeight,
      offsetY: this.ntfAniParameters?.ntfItemClipOffsetY,
      marginTopVal: marginTopVal
    }) : false;
  }

  private getAlignment() : Alignment {
    return this.isGroupExpanded ? Alignment.TopEnd : Alignment.End
  }

  private getScale(): number {
    if (Number.isNaN(this.outScale)) {
      return 1;
    }
    this.setClipParam();
    return this.outScale * this.groupItemScale;
  }

  private setClipParam(): void {
    if (!NotificationType.isDropdown(this.notificationType)) {
      this.clipParam = true;
      return;
    }
    // 缩小
    const isSlimDown = this.outScale * this.groupItemScale < 1;
    this.clipParam = this.ntfScrollAnimation.getClipParam(this.ntfAniParameters,
      this.ntfEntry, sDropDownPanelManager.isClearAll, this.radius, isSlimDown);
  }

  private getItemClipStyle(): NtfClipAnimStyle {
    let itemClipHeight = this.ntfAniParameters?.ntfItemClipHeight ?? 0;
    let itemWidth = this.slItemWidth?.itemWidth ?? 0;
    if (itemWidth <= 0 || itemClipHeight <= 0) {
      return DEFAULT_CLIP;
    }
    let absTranX = Math.abs(this.groupItemTranX);
    let offsetY = this.ntfAniParameters?.ntfItemClipOffsetY ?? 0;
    let groupItemTranX = NotificationType.isKeyguard(this.notificationType) ? this.groupItemTranX
      : NotificationUtils.getRTLValue(this.groupItemTranX);
    if (groupItemTranX < 0) {
      return new NtfClipAnimStyle()
        .buildWidth(itemWidth - absTranX)
        .buildHeight(itemClipHeight)
        .buildOffsetX(absTranX)
        .buildOffsetY(offsetY)
        .buildRadius(this.radius ?? 0);
    } else {
      return new NtfClipAnimStyle()
        .buildWidth(itemWidth - absTranX)
        .buildHeight(itemClipHeight)
        .buildOffsetX(0)
        .buildOffsetY(offsetY)
        .buildRadius(this.radius ?? 0);
    }
  }

  private ntfOnTouch = (event: TouchEvent): void => {
    if (event.type === TouchType.Down) {
      animateTo(NotificationConfig.NOTIFICATION_CLICK_ANIM, () => {
        this.groupItemScale = this.isGroupExpanded ? 0.98 : 0.95;
      })
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;
      return;
    }

    if (this.groupItemScale === 1) {
      return;
    }

    if (event.type === TouchType.Move) {
      if (Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
        Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4) {
        animateTo(NotificationConfig.NOTIFICATION_SCALE_ANIM, () => { this.groupItemScale = 1; })
      }
      return;
    }

    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      animateTo(NotificationConfig.NOTIFICATION_SCALE_ANIM, () => { this.groupItemScale = 1; })
      return;
    }
  }

  private collapseGroupNtf = (): void => {
    this.swipeController?.swipe2Collapse();
  }

  /**
   * 面板触摸事件down点变化
   */
  private onGlobalDownYChange(): void {
    if (!this.isSwipeExpand() || this.panelDownGlobalY == -1) {
      return;
    }
    const compId = TAG + '_GroupItem_' + this.ntfEntry?.getGroupTypeKey() + this.notificationType;
    let rectInfo: RectInfo = ItemUtils.getRectById(compId);
    if (CommonUtils.isInvalid(rectInfo)) {
      return;
    }
    // 横滑展开状态，down点不在条目区域内，则收起横滑状态
    let itemTop = rectInfo.top as number + this.itemTranslateY;
    let itemBottom = rectInfo.height as number + itemTop;
    if (NotificationType.isKeyguard(this.notificationType)) {
      itemBottom = (this.ntfAniParameters?.ntfItemClipHeight ?? 0) + itemTop;
    }
    if (this.panelDownGlobalY < itemTop || this.panelDownGlobalY > itemBottom) {
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
    const compId = TAG + '_GroupItem_' + this.ntfEntry?.getGroupTypeKey() + this.notificationType;
    let rectInfo: RectInfo = ItemUtils.getRectById(compId);
    if (CommonUtils.isInvalid(rectInfo)) {
      return;
    }
    // 横滑展开状态，down点不在条目区域内，则收起横滑状态
    let itemLeft = rectInfo.left as number;
    let itemRight = rectInfo.right as number;
    let groupItemTranX = NotificationUtils.getRTLValue(this.groupItemTranX);
    if (this.panelDownGlobalX > itemRight || this.panelDownGlobalX < itemLeft + groupItemTranX) {
      this.swipeController?.swipe2Collapse();
    }
  }

  /**
   * 监听收起的事件
   */
  private contractEvent(): void {
    if (this.contract && !NotificationType.isKeyguard(this.notificationType)) {
      this.isDragged = false;
      this.isGroupExpanded = false;
      (this.ntfEntry as NotificationEntry).isItemExpanded = this.isGroupExpanded;
      this.headerVM.setItemExpandState(this.isGroupExpanded);
    }
  }

  /**
   * 窗口可见性切换
   */
  private onWindowShowChange(): void {
    if (this.isNtfWindowShow) {
      return;
    }
    // 窗口隐藏时收起横滑状态
    this.swipeController?.swipe2Collapse();
  }

  /**
   * 通知滑动删除事件
   */
  private onNtfSwipeDeleteEvent = (event: NtfSwipeDeleteEvent): void => {
    if (event?.eventType === NtfSwipeDeleteEvent.EVENT_TYPE_START) {
      log.showDebug(`deleteAnimaSync start`);
      this.deleteAnimSyncFlag = true;
      return;
    }
    log.showDebug(`deleteAnimaSync end`);
    this.deleteAnimSyncFlag = false;
    if (this.deleteAnimSyncData) {
      this.onNtfDataUpdate(this.deleteAnimSyncData);
      this.deleteAnimSyncData = undefined;
    }
    AccessUtil.sendNtfRemoveAccessibility(false);
  }

  /**
   * 刷新子通知列表
   */
  private refreshChildrenList(): void {
    if (this.ntfEntry) {
      let size = Math.min(this.ntfEntry.childrenEntry?.length ?? 0, GROUP_MAX_SHOW_SIZE);
      // 收起状态，直接刷新，无需动效
      if (!this.isGroupExpanded) {
        if (this.ntfEntry && this.ntfEntry.childrenEntry) {
          this.ntfChildrenList = this.ntfEntry.childrenEntry.slice(0, size);
        }
        this.lastItemHashCode = this.ntfChildrenList[size - 1]?.hashCode;
        this.firstItemHashCode = this.ntfChildrenList[0]?.hashCode;
        return;
      }
      // 更新lastItemHashCode
      this.lastItemHashCode = this.ntfEntry.childrenEntry ? this.ntfEntry.childrenEntry[size - 1]?.hashCode : '';
      this.firstItemHashCode = this.ntfEntry.childrenEntry ? this.ntfEntry.childrenEntry[0]?.hashCode : '';
      // 更新数据
      this.refreshDataListWithAni((size) => {
        if (this.ntfEntry && this.ntfEntry.childrenEntry) {
          this.ntfChildrenList = this.ntfEntry.childrenEntry.slice(0, size);
        }
      }, size);
      log.showInfo(`notification child update ${this.ntfEntry.childrenEntry?.length} ${this.ntfChildrenList?.length}`);
    }
  }

  private refreshDataListWithAni(func: (size: number) => void, size: number): void {
    let isKg = NotificationType.isKeyguard(this.notificationType);
    let anim: AnimateParam = { duration: 350, curve: Curve.Friction }; // 堆叠效果同步动效
    if (isKg) {
      this.ntfAniParameters?.updateClipAnim(anim).setClipAnimWait().updateItemPresSize();
    }
    let delay = isKg && !this.isClicked ? ANIM_KG_DELAY : 0; // 锁屏面板时延
    this.isDataUpdate = true;
    animateTo({ delay: delay, duration: 350, curve: Curve.Friction,
      onFinish: () => {
        log.showInfo(`[ani_finish] refreshDataListWithAni`);
        this.isDataUpdate = false;
      }
    }, () => {
      func(size);
    })
  }

  /**
   * 刷新组通知个数
   */
  private refreshGroupCount(): void {
    if (this.ntfEntry) {
      // 隐藏通知内容
      this.isHideNtfContent = this.ntfEntry?.isHideContent;
      // 超过上限数量直接取上限数量，解决新增事件与删除超限通知事件不同步，计数抖动问题
      let totalCount = Math.min(ArrayUtils.getSize(this.ntfEntry?.childrenEntry), SINGLE_APP_LIMIT);
      let remainderCount = totalCount - GROUP_PRE_TWICE;
      if (remainderCount > 0) {
        ResUtils.getInnerStringNum($r('app.string.ntf_brief_remainder_count'), remainderCount).then((result: string) => {
          this.groupRemainderCount = result;
        });
      } else {
        this.groupRemainderCount = '';
      }
      // 隐藏通知内容时，几个通知
      if (this.isHideNtfContent) {
        ResUtils.getInnerPlural($r('app.plural.ntf_hide_content_count'), totalCount).then((result: string) => {
          this.groupCountHideText = result;
        });
      }
      log.showInfo(`refresh group count ${this.groupCountHideText} ${this.groupRemainderCount}`);
    }
  }

  /**
   * 是否为swipe展开状态
   *
   * @return true 展开
   */
  private isSwipeExpand(): boolean {
    return NotificationUtils.getRTLValue(this.groupItemTranX) < 0;
  }

  private updateItemTranxWithAnim(tranX: number): void {
    let isSwiping = tranX !== 0 || this.groupItemTranX !== 0;
    if (this.groupItemTranAnim == null) {
      this.groupItemTranX = tranX;
    } else {
      animateTo(this.groupItemTranAnim, () => {
        this.groupItemTranX = tranX;
      })
    }
    if (this.isGroupExpanded && this.outScale >= 1) {
      // 判断是否正在横滑需要裁切的通知
      this.clipParam = this.ntfAniParameters?.ntfItemClipHeight > 0 && isSwiping ?
        new Rect({ width: '100%', height: this.ntfAniParameters?.ntfItemClipHeight, radius: this.radius })
          .position({ y: this.ntfAniParameters?.ntfItemClipOffsetY })
        : true
    }
  }

  private updateDisplayButtonsHashCode(): void {
    if (this.displayButtonsHashCode != '') {
      animateTo({
        curve: curves.interpolatingSpring(0, 1, 225, 25),
        onFinish: () => {
          log.showInfo(`[aniTo_finish] updateDisplayButtonsHashCode`);
        }
      }, () => {
        this.displayButtonsHashCode = '';
      })
    }
  }

  /**
   * 锁屏组通知收起态点击操作
   *
   * @param clickCount 点击计数值, 区分单双击
   */
  private onKgGroupBriefTap(clickCount: number = 1): void {
    if (!this.canExpand || this.isHideNtfContent) {
      if (this.isHideNtfContent && this.isSwipeExpand() && clickCount === 1) {
        this.swipeController?.swipe2Collapse();
        return;
      }

      if (!this.ntfEntry?.childrenEntry || this.ntfEntry.getChildrenSize() === 0) {
        log.showError(`onKgGroupBriefTap, ntf children is null, groupKey: ${this.ntfEntry?.getGroupKey()}`);
        return;
      }
      let firstChild = this.ntfEntry?.childrenEntry[0];

      if (!this.ntfEntry.childrenEntry[0].wantAgent) {
        log.showInfo(`onKgGroupBriefTap, no wantAgent, clickCount: ${clickCount}, hash: ${firstChild.hashCode}`);
        this.kgBriefClickTip(false);
        return;
      }

      if (clickCount === ScreenLockNotificationConst.NTF_FIRST_CLICK) {
        log.showInfo(`onKgGroupBriefTap, clickCount: 1, hash: ${firstChild.hashCode}`);
        this.kgBriefClickTip(true);
      } else if (clickCount === ScreenLockNotificationConst.NTF_SECOND_CLICK) {
        log.showInfo(`onKgGroupBriefTap, clickCount: 2, hash: ${firstChild.hashCode}`);
        this.singleItemVm.startAgentOnLock(true, firstChild, true);
      }
      return;
    }
    if (this.isAccessibilityMode) {
      log.showInfo('click keyguard group brief in accessibility mode');
      this.onGroupBriefClick(ScreenLockNotificationConst.NTF_SECOND_CLICK);
      return;
    }
    this.onGroupBriefClick(clickCount);
  }

  /**
   * 组通知收起态点击操作
   *
   * @param clickCount 点击计数值, 区分单双击
   */
  private async onGroupBriefClick(clickCount: number = 1): Promise<void> {
    if (!NotificationType.isKeyguard(this.notificationType)) {
      // 组通知展开收起动效延迟响应，保证卡片回弹动效优先下发，减少组通知展开收起场景响应时延
      await SystemUICommonUtil.sleep(10);
    }
    // 当swipe展开时，点击收起
    if (this.isSwipeExpand()) {
      this.swipeController?.swipe2Collapse();
      return;
    }
    // 锁屏场景点击检测
    if (this.kgCheckClickTip(clickCount)) {
      return;
    }
    log.showInfo(`UnfoldNtAni on group brief click: ${this.ntfEntry?.toSimpleString()} , ${this.groupItemTranX}`);
    // 点击展开分组
    this.isClicked = true;
    TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_UNFOLD_NOTIFICATION);
    // 裁切动效曲线保持一致
    this.ntfAniParameters?.updateClipAnim({
      duration: NotificationGroupExpandAnimation.duration,
      curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
    })
      .setClipAnimWait().updateItemPresSize();
    EvtBus.post(GroupItemExpandingEvent, new GroupItemExpandingEvent(!this.isGroupExpanded,
      this.ntfEntry?.getGroupTypeKey()));
    animateTo({
      duration: NotificationGroupExpandAnimation.duration,
      curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
      onFinish: () => {
        log.showInfo(`[ani_finish] onGroupBriefClick`);
        this.isClicked = false;
        TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_UNFOLD_NOTIFICATION);
      }
    }, () => {
      this.isGroupExpanded = !this.isGroupExpanded;
      if (this.isGroupExpanded) {
        this.scrollUpIfNeed(this.ntfEntry?.getGroupTypeKey());
      }
      AccessibilityUtil.requestFocusAccessibility('NotificationHeader_' + this.ntfEntry?.getGroupTypeKey());
    });
    (this.ntfEntry as NotificationEntry).isItemExpanded = this.isGroupExpanded;
    this.headerVM.setItemExpandState(this.isGroupExpanded);
    // 用户操作打点
    NotificationSysEventReporter.notificationFoldGroup({
      OPERATE_METHOD: 0,
      DISPLAY_SCENE: NotificationType.isKeyguard(this.notificationType) ? 2 : 4,
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.childrenEntry?.map((entry) => entry.slotType).join(','),
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      TIME_STAMP: NotificationUtils.getNtfTimeStampByType(this.notificationType)
    });
  }

  /**
   * 锁屏通知点击发出弹窗提醒检测
   *
   * @param clickCount 点击计数值, 区分单双击
   * @returns 是否发出弹窗提醒
   */
  private kgCheckClickTip(clickCount: number): boolean {
    if (!(NotificationType.isKeyguard(this.notificationType) || this.isNtfKeyguard())) {
      return false;
    }
    let componentId: string = this.isNtfKeyguard() ?
    ScreenLockNotificationConst.NTF_OUT_DROPDOWN_PANEL_KEY_GUARD_TIP : ScreenLockNotificationConst.NTF_KEY_GUARD_TIP;
    if (clickCount === ScreenLockNotificationConst.NTF_FIRST_CLICK && this.isKeyguardLocked()) {
      screenLockSysFloatTipControl.setTipMessage(componentId,
        ResUtils.getInnerStringByName(ScreenLockNotificationConst.DOUBLE_CLICK_EXPAND_TIP));
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, true,
        ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
      return true;
    }
    screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, false);
    return false;
  }

  private kgBriefClickTip(hasWantAgent: boolean): void {
    let componentId: string = ScreenLockNotificationConst.NTF_KEY_GUARD_TIP;
    let promptTip: string =
      hasWantAgent ? ScreenLockNotificationConst.KG_NTF_CLICK_TIP : ScreenLockNotificationConst.KG_NTF_NO_CONTENT_TIP;
    screenLockSysFloatTipControl.setTipMessage(componentId,
      ResUtils.getInnerStringByName(promptTip));
    screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, true,
      ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
  }

  getNtfEntry(): NotificationEntry | null {
    if (!this.ntfEntry?.childrenEntry || this.ntfEntry.getChildrenSize() === 0) {
      log.showError(`getNtfEntry, ntf children is null, groupKey: ${this.ntfEntry?.getGroupKey()}`);
      return null;
    }
    return this.ntfEntry?.childrenEntry[0];
  }

  getNtfType(): number {
    return this.notificationType;
  }

  private isKeyguardLocked() {
    return this.isKeyguardLock || this.isSecureAndLocked;
  }

  private isNtfKeyguard() {
    return this.isNeedPanelInScreenLock && this.isLockScreen;
  }

  private onSingleClick(): void {
    if (!this.canExpand || this.isHideNtfContent) {
      if (this.isHideNtfContent && this.isSwipeExpand()) {
        this.swipeController?.swipe2Collapse();
      }
      return;
    }
    this.onGroupBriefClick();
  }

  private onLockStateChange(): void {
    if (this.isKeyguardLock || bannerMgr.isSupportDouble(this.isNeedPanelInScreenLock, this.isLockScreen
      , this.isSecureAndLocked)) {
      this.itemGestureModifier.isSupportDouble = true;
    } else {
      this.itemGestureModifier.isSupportDouble = false;
    }
  }

  private initItemGestureModifier() {
    this.itemGestureModifier.callback = {
      handleDoubleTwiceClick: () => this.onKgGroupBriefTap(2),
      handleDoubleOnceClick: () => this.onKgGroupBriefTap(),
      handleSingleClick: () => this.onSingleClick()
    };
    this.onLockStateChange();
  }

  private deinitItemGestureModifier() {
    this.itemGestureModifier.callback = undefined;
  }
}
