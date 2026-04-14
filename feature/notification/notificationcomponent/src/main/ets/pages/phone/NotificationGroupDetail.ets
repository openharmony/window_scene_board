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
import { NotificationHeader, OnItemExpandListener } from '../common/NotificationHeader';
import { NotificationSingleItem, buildDivider } from './NotificationSingleItem';
import { NtfHeaderVM } from '../../vm/NtfHeaderVM';
import {
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import GroupChildNtfDataChannel from '../../vm/GroupChildNtfDataChannel';
import { NotificationType } from '../../common/NotificationType';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { AccessibilityUtil, FrameCount, NotificationSysEventReporter } from '@ohos/systemuicommon';
import { NtfAnimVM } from '../../vm/NtfAnimVM';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import { NotificationUtils } from '../../common/NotificationUtils';
import { OverlayAnimData } from '@ohos/systemuicommon/Index';
import { NotificationAnimationParas } from '../../common/NotificationAnimationParas';
import { GroupItemExpandingEvent } from '../../common/event/NotificationEvent';
import { NotificationGroupExpandAnimation } from '../../animation/NotificationGroupExpandAnimation';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'NotificationGroupDetail';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const ANIM_KG_DELAY = 25;

@Component
export struct NotificationGroupDetail {
  /**
   * 分帧处理对象，仅需要记录到第2帧
   */
  private frameCount?: FrameCount;
  @State frameIndex: number = 0;
  /**
   * 分组通知数据
   * 分组通知对象一般不会变
   */
  private ntfEntry?: NotificationEntry;

  /**
   * 当前分组是否展开
   */
  @Link isGroupExpanded: boolean;

  /**
   * 是否隐藏通知内容
   */
  @Consume isHideNtfContent: boolean;

  /**
   * 通知列表类型
   */
  @Consume notificationType: number;

  /**
   * 分组子通知列表
   */
  @Link ntfChildrenList: Array<NotificationEntry>;

  /**
   * 圆角
   */
  @Prop radius: number = 0;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 通知动效vm
   */
  ntfAnimVM: NtfAnimVM | undefined = undefined;

  /**
   * 记录条目位置
   */
  groupItemArea: Area | undefined = undefined;

  /**
   * 组通知最后一个Item的hash code，用于判断是否是最后一个item。
   */
  @Prop lastItemHashCode: string = '';
  /**
   * 组通知第一个item的hash code
   */
  @Prop firstItemHashCode: string = '';
  /**
   * 通知是否点击展开
   */
  @Link isClicked: boolean;
  /**
   * 分组头数据VM
   */
  headerVM: NtfHeaderVM = new NtfHeaderVM();

  /**
   * 条目横滑控制器
   */
  private swipeController?: NtfItemSwipeController;

  /**
   * 组通知与子通知数据交换
   */
  private groupChildDataChannel: GroupChildNtfDataChannel | null = null;

  private isUseEffect: boolean = false;

  /**
   * 简介图标距离顶部的位置
   */
  @State briefIconPositionY: number = 0;

  /**
   * 组通知横滑平移距离
   */
  @Link groupItemTranX: number;

  @Link overlayAnimData: OverlayAnimData;

  @Prop isNeedPanelInScreenLock: boolean = false;
  @Prop isLockScreen: boolean = false;
  @Prop isSecureAndLocked: boolean = false;

  /**
   * 是否扩展新形态小外屏
   */
  @Prop isOuterHomeFolded: boolean = false;

  private ancestorsOverlayAnimData?: OverlayAnimData[];

  /**
   * 动效收起组通知回调
   */
  private animCollapse?: (param: AnimateParam) => void;

  /**
   * 是否开启提亮，默认不开启
   */
  private isColorModeEnable: boolean = false;

  /**
   * 是否为通知中心通知
   */
  private isNtfCenterGroupItem:boolean = false;

  // 叠加动效参数
  @ObjectLink ntfAniParameters: NotificationAnimationParas;

  private onFrameCallback = (count: number): void => {
    // 第2帧
    if (count === 2 || count === 3) {
      animateTo({
        duration: NotificationGroupExpandAnimation.duration,
        curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
      }, () => {
        this.frameIndex = count;
      });
    }
  }

  private isFrameValid(index: number): boolean {
    // 仅手机通知中心创建组通知展开态卡片场景，分帧；
    if (!NotificationType.isDropdown(this.notificationType)) {
      return true;
    }

    // 第1帧创建第1张卡片
    if (index < 1) {
      return true;
    }

    // 第2帧创建第2~3张卡片
    if (index < 3 && this.frameIndex >= 2) {
      return true;
    }

    // 第3帧创建剩余卡片
    return (this.frameIndex >= 3) ? true : false;
  }

  private itemExpandListener : OnItemExpandListener = (isGroupExpanded: boolean, isNtfWindowShow?: boolean) => {
    log.showInfo('FoldNtAni on group brief click: ' + this.ntfEntry?.toSimpleString());
    // 收缩动画
    this.isClicked = true;
    let groupItemTranX = NotificationUtils.getRTLValue(this.groupItemTranX);
    // 当swipe展开时，点击收起
    if (groupItemTranX < 0) {
      this.swipeController?.swipe2Collapse();
    } else {
      if (!(isNtfWindowShow ?? true)) {
        this.isClicked = false;
        this.isGroupExpanded = false;
      } else {
        TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_FOLD_NOTIFICATION);
        EvtBus.post(GroupItemExpandingEvent, new GroupItemExpandingEvent(false, this.ntfEntry?.getGroupTypeKey()));
        // 裁剪动效保持一致
        let clipAnim: AnimateParam =
          { duration: NotificationGroupExpandAnimation.duration, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE };
        this.animCollapse?.(clipAnim);
        let delay = NotificationType.isKeyguard(this.notificationType) ? ANIM_KG_DELAY : 0;
        animateTo({
          delay: delay,
          duration: NotificationGroupExpandAnimation.duration,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
          onFinish: () => {
            this.isClicked = false;
            TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_FOLD_NOTIFICATION);
          }
        }, () => {
          this.isGroupExpanded = false;
          AccessibilityUtil.requestFocusAccessibility('NotificationGroupItem_GroupBrief_' +
          this.ntfEntry?.getGroupTypeKey());
        });
      }
    };

    // 用户操作打点
    NotificationSysEventReporter.notificationFoldGroup({
      OPERATE_METHOD: 1,
      DISPLAY_SCENE: NotificationType.isKeyguard(this.notificationType) ? 2 : 4,
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.childrenEntry?.map((entry) => entry.slotType).join(','),
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      TIME_STAMP: NotificationUtils.getNtfTimeStampByType(this.notificationType)
    });
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    if (NotificationType.isDropdown(this.notificationType)) {
      this.frameCount = new FrameCount(this.onFrameCallback);
      // 仅监听前2帧。
      this.frameCount.start(3);
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Column() {
      // 分组头
      NotificationHeader({
        ntfEntry: this.ntfEntry,
        isHideContent: this.isHideNtfContent ? true : false,
        itemExpandListener: this.itemExpandListener,
        headerVm: this.headerVM,
        swipeController: this.swipeController,
        colorModeVM: this.colorModeVM,
        isClicked: this.isClicked,
        briefIconPositionY: this.briefIconPositionY,
        isOuterHomeFolded: this.isOuterHomeFolded
      })
        .borderRadius({ topLeft: this.radius, topRight: this.radius })

      buildDivider(true, this.colorModeVM, this.ntfEntry?.overlayIcon, this.ntfEntry?.overlayIconStyle);

      this.buildListItem()
    }
    .width(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentWidth : undefined)
    .height(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentHeight : undefined)
    .opacity(this.overlayAnimData.isAnimating ? this.overlayAnimData.contentOpacity : undefined)
  }

  @Builder
  buildListItem() {
    ForEach(this.ntfChildrenList, (entry: NotificationEntry, index: number) => {
      if (this.isFrameValid(index)) {
        NotificationSingleItem({
          ntfEntry: entry,
          isInGroup: true,
          lastItemHashCode: this.lastItemHashCode,
          firstItemHashCode: this.firstItemHashCode,
          radius: this.radius,
          groupChildNtfDataChannel: this.groupChildDataChannel as GroupChildNtfDataChannel,
          colorModeVM: this.colorModeVM,
          ntfAnimVM: this.ntfAnimVM,
          isUseEffect: !this.isColorModeEnable && this.isUseEffect, // 组通知开启提亮后则item无需模糊
          index: index as number,
          lastIndex: this.ntfChildrenList.length - 1,
          isClicked: this.isClicked,
          isNtfCenterGroupItem: this.isNtfCenterGroupItem,
          isColorModeEnable: !this.isColorModeEnable, // 组通知已开启，则item不开启
          itemActionBtnChange: !NotificationType.isKeyguard(this.notificationType) ? undefined : (anim) => {
            this.animCollapse?.(anim); // 缓存裁剪动效，标记裁切动效等待
          },
          ancestorsOverlayAnimData: [this.overlayAnimData].concat(...(this.ancestorsOverlayAnimData ?? [])),
          isNeedPanelInScreenLock: this.isNeedPanelInScreenLock,
          isLockScreen: this.isLockScreen,
          isSecureAndLocked: this.isSecureAndLocked,
          isOuterHomeFolded: this.isOuterHomeFolded,
          ntfAniParameters: new NotificationAnimationParas(0, 0, 0, 1, 0),
        })
      }
    }, (entry: NotificationEntry, index: number) => {
      return entry.buildFlag;
    })
  }
}
