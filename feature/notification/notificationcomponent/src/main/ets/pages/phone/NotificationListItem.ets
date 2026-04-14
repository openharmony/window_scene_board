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

import { CommonData } from '@ohos/controlcentercommon/Index';
import { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationGroupItem } from './NotificationGroupItem';
import { NotificationSingleItem } from './NotificationSingleItem';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppBubbleWrapper } from '@ohos/launchercommon/src/main/ets/uicomponents/AppBubbleWrapper';
import { NotificationConstants } from '../../common/NotificationConstants';
import { NotificationAnimationParas } from '../../common/NotificationAnimationParas';
import { NotificationUtils } from '../../common/NotificationUtils';
import { NotificationType } from '../../common/NotificationType';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import { NotificationMenuComponent } from '../common/NotificationMenuComponent';
import { DarkModeState, FrameCount, immersiveKgMgr,
  NotificationCreatorType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationItemStyle } from '../../vm/style/NotificationItemStyle';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NtfAnimVM } from '../../vm/NtfAnimVM';
import {
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { OverlayAnimData } from '@ohos/systemuicommon/Index';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';

import display from '@ohos.display';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'NotificationListItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DEFAULT_CENTER_Y = '50';
const RIGHT_MENU_LENGTH = 3;
const MENU_OFFSET_DISTANCE = 8;

/**
 * 通知条目组件
 */
@Component
export struct NotificationListItem {
  /**
   * 组通知数据
   */
  @State ntfGroupEntry: NotificationEntry | undefined = undefined;
  /**
   * 是否显示分组条目
   */
  @State isShowGroupItem: boolean = false;

  @Prop bgBrightnessOption : BrightnessOptions | undefined = undefined;
  @Prop dividerBrightnessOption : BrightnessOptions | undefined = undefined;
  /**
   * 锁屏是否加锁状态
   */
  @Consume isKeyguardLock: boolean;

  /**
   * 圆角
   */
  @Prop radius: number = 0;
  @Consume notificationType: number;
  @ObjectLink ntfAniParameters: NotificationAnimationParas;
  private isUseEffect: boolean = true;

  @StorageLink('DarkModeModel_DarkModeStatus') darkModeDataPc: CommonData = new CommonData();

  @StorageLink('Notification_DarkModeModel_DarkModeStatus') darkModeData: DarkModeState = new DarkModeState();

  updateAnimationParas?: Function | null = null;

  @Prop canExpand: boolean = true;

  @Prop isGestureEnabled: boolean = true;

  /**
   * 通知条目样式
   */
  @State itemStyle: NotificationItemStyle = notificationStyle.item;

  private isGroupExpand: boolean = this.ntfGroupEntry?.isItemExpanded ?? false;

  @Prop itemTranslateY: number = 0;

  /**
   * 分帧处理对象，仅需要记录到第2帧
   */
  @State frameCount: FrameCount = new FrameCount();

  @State dataChangeInterrupt?: PromiseInterrupt = undefined;

  /**
   * 新的单通知实例
   */
  @Provide newSingleNft?: NotificationEntry = undefined;

  colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 动效vm
   */
  ntfAnimVM: NtfAnimVM | undefined = undefined;

  /**
   * 第一条更多通知的动效延迟时间
   */
  private fisrtExtraNtfDelayTime: number | undefined = undefined;
  /**
   * 是否为更多通知
   */
  private isInExtraNtfList: boolean = false;

  /**
   * 锁屏标示是否滑动卡片
   */
  private touchListItemCallback?: (isTouching: boolean) => void;

  private changeAppPinTopConfig?: (enable: boolean) => void;

  @Prop isDropDownAniFin: boolean = false;

  /**
   * 记录展示按钮的通知的哈希值
   */
  @Provide displayedNtfHashCode: string = '';
  private changeItemExpand = (isExpanded: boolean) : void => {
    this.isGroupExpand = isExpanded;
    this.refreshGroupItem();
  };

  @State @Watch('overlayAnimDataChanged') overlayAnimData: OverlayAnimData = new OverlayAnimData();

  @State protectedVm: AppProtectedVm = AppProtectedVm.get();
  @Prop isNeedPanelInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop isLockScreen: boolean = false;
  @Prop isSecureAndLocked: boolean = false;

  @State ntfCount: number = 1;
  // 是否半叠状态
  @Prop @Watch('checkNeedOffset') isHalfFold: boolean = false;
  // 触发右键（长按）菜单的y坐标
  clickY: number = 0;
  // 菜单避让中轴区偏移量
  @State menuOffset: Position = {x: 0, y: 0};
  // 菜单高度
  menuHeight: number = 0;

  @State hoverScaleRate: number = 1;

  private scrollUpIfNeed = (groupTypeKey?: string) : void => {};

  aboutToAppear(): void {
    log.showInfo('AboutToAppear %{public}s', this.ntfGroupEntry?.getGroupTypeKey());
    this.overlayAnimData.setTag(`${TAG}_${this.ntfGroupEntry?.getGroupTypeKey()}`);
    // 注册通知数据变化监听
    this.ntfGroupEntry?.registerDataUpdateListener(this);
    // 初始化分组条目标记
    this.refreshGroupItem();
    // 更新通知数量
    this.refreshNtfCount();

    if (!NotificationType.isKeyguard(this.notificationType)) {
      this.frameCount.start(2);
    }
    if (DeviceHelper.isBigScreenMachine()) {
      const singleMenuHeight = ResUtils.getNumber($r('app.float.ntf_pc_menu_item_height'));
      const menuMarginHeight = ResUtils.getNumber($r('app.float.ntf_pc_menu_item_margin_top'));
      const menuBottomHeight = ResUtils.getNumber($r('app.float.ntf_pc_click_menu_padding_bottom'))
      this.menuHeight = (singleMenuHeight + menuMarginHeight) * RIGHT_MENU_LENGTH + menuBottomHeight;
    }
  }

  aboutToDisappear(): void {
    log.showDebug('aboutToDisappear');
    this.ntfGroupEntry?.unregisterDataUpdateListener(this);
  }

  checkNeedOffset() {
    if (!DeviceHelper.isBigScreenMachine() || !this.isHalfFold) {
      return;
    }
    const vpBSideHeight = ArkUIAdapter.px2vp(display.getDisplayByIdSync(0).height);
    if (this.clickY < vpBSideHeight && ((this.clickY + this.menuHeight + MENU_OFFSET_DISTANCE) > vpBSideHeight)) {
      this.menuOffset.y = (vpBSideHeight - this.clickY - this.menuHeight - MENU_OFFSET_DISTANCE);
    } else {
      this.menuOffset.y = 0;
    };
    log.showInfo(`checkNeedOffset this.menuOffset.y ${this.menuOffset.y}, menuHeight:${this.menuHeight}`);
  }

  overlayAnimDataChanged(): void {
    log.showInfo('overlayAnimDataChanged to %{public}s', this.overlayAnimData.toStr());
  }

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  async onNtfDataUpdate(newEntry: NotificationEntry): Promise<void> {
    // 数据刷新拦截等待
    await this.dataChangeInterrupt?.awaitInterrupt();
    this.ntfGroupEntry = newEntry;
    let entry = this.getNtfEntry();
    if (entry && this.needBuildLockNtf()) {
      this.newSingleNft = entry;
      this.refreshNtfCount();
    }
    this.refreshGroupItem();
    if (this.updateAnimationParas) {
      log.showInfo(TAG, `NotificationListItem onNtfDataUpdate in`);
      this.updateAnimationParas(this.ntfGroupEntry?.getGroupKey() || '');
    }
    log.showInfo('NotificationListItem onNtfDataUpdate: ' + this.ntfGroupEntry?.getGroupTypeKey());
  }

  @Builder
  buildGroupItem() {
    NotificationGroupItem({
      ntfEntry: this.ntfGroupEntry,
      radius: this.radius,
      colorModeVM: this.colorModeVM,
      ntfAnimVM: this.ntfAnimVM,
      isUseEffect: this.isUseEffect,
      canExpand: this.canExpand,
      isGestureEnabled: this.isGestureEnabled,
      itemTranslateY: this.itemTranslateY,
      ntfAniParameters: this.ntfAniParameters,
      outScale: this.ntfAniParameters?.clearAnimScale ?? 1,
      changeItemExpand: this.changeItemExpand,
      outScaleCenterY: this.ntfAniParameters?.ntfItemRotateCenterY ?? DEFAULT_CENTER_Y,
      dataChangeInterrupt: this.dataChangeInterrupt,
      ancestorsOverlayAnimData: [this.overlayAnimData],
      isNeedPanelInScreenLock: this.isNeedPanelInScreenLock,
      isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
      isLockScreen: this.isLockScreen,
      isSecureAndLocked: this.isSecureAndLocked,
      scrollUpIfNeed: this.scrollUpIfNeed,
    })
  }

  @Builder
  buildSingleItem() {
    if (DeviceHelper.isPC()) {
      this.buildSingleItemPCContent()
    } else {
      this.buildSingleItemContent()
    }
  }

  @Builder
  buildSingleItemContent() {
    NotificationSingleItem({
      ntfCount: this.ntfCount,
      ntfEntry: this.getNtfEntry(),
      groupEntryCB: this.getNtfGroupEntry,
      isInGroup: false,
      radius: this.radius,
      colorModeVM: this.colorModeVM,
      ntfAnimVM: this.ntfAnimVM,
      isUseEffect: this.isUseEffect,
      fisrtExtraNtfDelayTime: this.fisrtExtraNtfDelayTime,
      isGestureDisable: !this.isGestureEnabled,
      itemTranslateY: this.itemTranslateY,
      itemClipHeight: this.ntfAniParameters?.ntfItemClipHeight,
      itemClipOffsetY: this.ntfAniParameters?.ntfItemClipOffsetY,
      itemActionBtnChange: !NotificationType.isKeyguard(this.notificationType) ? undefined : (anim) => {
        this.ntfAniParameters?.updateClipAnim(anim) // 按钮显隐动效时，同步切割动效
          .setClipAnimWait().updateItemPresSize(); // 标记item高度预切换
      },
      isTempDisableEffect: this.ntfAniParameters?.isTempDisableEffect(),
      ntfItemTranslateY: this.ntfAniParameters?.ntfItemTranslateY,
      isExtraItemClicked: this.isInExtraNtfList,
      isItemEnable: this.ntfAniParameters?.isItemEnable() ?? true,
      ntfAniParameters: this.ntfAniParameters,
      ancestorsOverlayAnimData: [this.overlayAnimData],
      isDropDownAniFin: this.isDropDownAniFin,
      isNeedPanelInScreenLock: this.isNeedPanelInScreenLock,
      isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
      isLockScreen: this.isLockScreen,
      isSecureAndLocked: this.isSecureAndLocked,
    })
      // 当按钮展开时，为了增加按钮的热区，不进行裁剪
      .clip(this.getSingleItemClip())
      .borderRadius(this.radius)
  }

  @Builder
  buildSingleItemPCContent() {
    NotificationSingleItem({
      ntfCount: this.ntfCount,
      ntfEntry: this.getNtfEntry(),
      groupEntryCB: this.getNtfGroupEntry,
      isInGroup: false,
      radius: this.radius,
      colorModeVM: this.colorModeVM,
      ntfAnimVM: this.ntfAnimVM,
      isUseEffect: this.isUseEffect,
      fisrtExtraNtfDelayTime: this.fisrtExtraNtfDelayTime,
      isGestureDisable: !this.isGestureEnabled,
      itemTranslateY: this.itemTranslateY,
      itemClipHeight: this.ntfAniParameters?.ntfItemClipHeight,
      itemClipOffsetY: this.ntfAniParameters?.ntfItemClipOffsetY,
      itemActionBtnChange: !NotificationType.isKeyguard(this.notificationType) ? undefined : (anim) => {
        this.ntfAniParameters?.updateClipAnim(anim) // 按钮显隐动效时，同步切割动效
          .setClipAnimWait().updateItemPresSize(); // 标记item高度预切换
      },
      isTempDisableEffect: this.ntfAniParameters?.isTempDisableEffect(),
      ntfItemTranslateY: this.ntfAniParameters?.ntfItemTranslateY,
      isExtraItemClicked: this.isInExtraNtfList,
      isItemEnable: this.ntfAniParameters?.isItemEnable() ?? true,
      ntfAniParameters: this.ntfAniParameters,
      ancestorsOverlayAnimData: [this.overlayAnimData],
      isDropDownAniFin: this.isDropDownAniFin,
      isNeedPanelInScreenLock: this.isNeedPanelInScreenLock,
      isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
      isLockScreen: this.isLockScreen,
      isSecureAndLocked: this.isSecureAndLocked,
    })
      .onHover((isHover: boolean) => {
        this.hoverScaleRate = (isHover && DeviceHelper.isPC()) ? 1.02 : 1;
      })
      .scale({x: this.hoverScaleRate, y: this.hoverScaleRate})
      .animation({duration: 300, curve: Curve.Sharp})
      // 当按钮展开时，为了增加按钮的热区，不进行裁剪
      .clip(this.getSingleItemClip())
      .borderRadius(this.radius)
  }

  private getNtfGroupEntry = (): NotificationEntry | undefined => {
    return this.ntfGroupEntry;
  }

  private getSingleItemClip(): boolean {
    log.showInfo('GetSingleItemClip [%{public}s] [%{public}s] [%{public}s] %{public}d', this.overlayAnimData.isAnimating
      , this.displayedNtfHashCode, this.getNtfEntry()?.hashCode, this.itemStyle.shadow === undefined,
      this.notificationType);
    if (this.overlayAnimData.isAnimating || this.displayedNtfHashCode === this.getNtfEntry()?.hashCode) {
      return false;
    }
    if (NotificationType.isPc(this.notificationType)) {
      return true;
    }
    return !this.itemStyle.shadow || (!this.isKeyguardLock && NotificationType.isDropdown(this.notificationType));
  }

  build() {
    Stack() {
      // 分帧处理:从第2帧开始创建部分子组件
      if (!CommonUtils.isInvalid(this.ntfGroupEntry) && (this.isFrameValid() || this.isInExtraNtfList )) {
        if (this.needBuildLockNtf()) {
          this.buildSingleItem()
        } else if (this.isShowGroupItem) {
          // 分组通知
          this.buildGroupItem()
        } else {
          // 单通知
          this.buildSingleItem()
        }
      }
    }
    .id(this.getStackId())
    .width('100%')
    .translate({
      y: NotificationUtils.getNtfItemTransY(this.ntfAniParameters)
    })
    .enabled(this.ntfAniParameters?.isItemEnable() ?? true)
    .opacity(NotificationUtils.getNtfItemOpacity(this.ntfAniParameters))
    // 组通知缩放效果内部实现
    .scale(this.isShowGroupItem && !this.needBuildLockNtf() ? undefined : {
      x: NotificationUtils.getNtfItemScale(this.ntfAniParameters),
      y: NotificationUtils.getNtfItemScale(this.ntfAniParameters),
      centerX: '50%',
      centerY: NotificationType.isDropdown(this.notificationType) ? this.ntfAniParameters?.ntfItemRotateCenterY : '50%'
    })
    .rotate({ x: 1, angle: NotificationUtils.getNtfItemRotateAngle(this.ntfAniParameters) })
    .bindContextMenu(this.isShowRightMenu() ? this.RightClickMenuBuilder :
      undefined, ResponseType.RightClick, {preview: MenuPreviewMode.IMAGE,
      offset: this.menuOffset})
    .bindContextMenu(this.isShowRightMenu() ? this.RightClickMenuBuilder :
      undefined, ResponseType.LongPress, {offset: this.menuOffset})
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.touchListItemCallback?.(false);
      } else {
        if (this.clickY !== event.touches[0].windowY) {
          this.clickY = event.touches[0].windowY;
          this.checkNeedOffset();
        }
        this.touchListItemCallback?.(true);
      }
    })
    .onMouse((event: MouseEvent) => {
      if (event.button === MouseButton.Right && event.action === MouseAction.Press) {
        this.clickY = event.windowY;
        this.checkNeedOffset();
      }
    })
  }

  @Builder
  RightClickMenuBuilder() {
    NotificationMenuComponent({
      ntfEntry : this.ntfGroupEntry,
      changeAppPinTopConfig: this.changeAppPinTopConfig
    })
  }

  /**
   * 应用处于保护状态下, 非实况通知加锁
   * 锁屏场景下保护态应用通知需要适配豁免名单，这里要单独处理--保护态 && 不是锁屏通知
   *
   * @returns
   */
  private needBuildLockNtf(): boolean {
    return this.protectedVm.isProtected(this.getNtfEntry()?.bundleIdxTag) && !this.getNtfEntry()?.isLiveType() &&
      !((NotificationType.isKeyguard(this.notificationType) || NotificationType.isAod(this.notificationType)));
  }

  private isFrameValid(): boolean { // 分帧有效性
    if (NotificationType.isKeyguard(this.notificationType)) { // 锁屏面板不分帧
      return true;
    }
    return DeviceHelper.isPC() || (this.frameCount.value > 1);
  }

  /**
   * 刷新分组条目标记状态
   */
  private refreshGroupItem(): void {
    const isPrevShowGroupItem = this.isShowGroupItem;
    this.isShowGroupItem = this.ntfGroupEntry?.isGroup! &&
      (this.ntfGroupEntry?.getChildrenSize()! > 1 || this.isGroupExpand);

    // 由组通知=>单通知时, 记录更新后的单通知实例
    if (isPrevShowGroupItem && !this.isShowGroupItem) {
      this.newSingleNft = this.ntfGroupEntry?.getFirstChildEntry();
    } else {
      this.newSingleNft = undefined;
    }
  }

  /**
   * 是否允许右键点击弹框
   *
   * @return true 允许弹框
   */
  private isShowRightMenu(): boolean {
    if (CommonUtils.isInvalid(this.ntfGroupEntry)) {
      return false;
    }

    if (this.ntfGroupEntry?.creatorType === NotificationCreatorType.SA) {
      log.showInfo(`ntf: ${this.getNtfEntry()?.hashCode} isSA, not show Right Menu`);
      return false;
    }

    if (!NotificationType.isPc(this.notificationType)) {
      log.showInfo(`ntf: ${this.getNtfEntry()?.hashCode} is not PC, not show Right Menu`);
      return false;
    }

    if (this.ntfGroupEntry?.isCollaNotification) {
      log.showInfo(`ntf: ${this.getNtfEntry()?.hashCode} isCollaNotification, not show Right Menu`);
      return false;
    }

    return !this.ntfGroupEntry?.isSettingIgnore;
  }

  /**
   * 获取通知实体
   * 1、单通知直接返回
   * 2、保护态组通知取最新的，非保护态组通知取最早的
   * @returns
   */
  private getNtfEntry(): NotificationEntry | undefined {
    if (!this.ntfGroupEntry?.isGroup) {
      return this.ntfGroupEntry;
    } else if (this.protectedVm.isProtected(this.ntfGroupEntry?.getLatestChildEntry()?.bundleIdxTag)) {
      return this.ntfGroupEntry?.getLatestChildEntry();
    }
    return this.ntfGroupEntry?.getFirstChildEntry();
  }

  private getStackId(): string {
    return TAG + '_' + this.notificationType + '_' + this.getNtfEntry()?.getGroupTypeKey() + '_' +
      this.getNtfEntry()?.hashCode;
  }

  private refreshNtfCount(): void {
    if (this.needBuildLockNtf()) {
      if (this.ntfGroupEntry?.isGroup) {
        this.ntfCount = this.ntfGroupEntry.childrenEntry!.length;
      }
    }
  }
}
