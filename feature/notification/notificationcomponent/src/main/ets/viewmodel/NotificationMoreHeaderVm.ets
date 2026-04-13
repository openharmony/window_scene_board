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

import { AnimateToScheduleUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  AccessibilityVm,
  INotificationMoreHeaderVm,
  INotificationMoreVm,
  NotificationBaseVm,
  ResourceVm
} from '@ohos/systemuicommon/newIndex';
import { MoreNotificationCollapsedAnimation } from '../animation/MoreNotificationCollapsedAnimation';
import {
  NotificationMoreHeaderModel
} from '@ohos/systemuicommon/src/main/ets/notification/model/NotificationMoreHeaderModel';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import { SystemUICommonUtil } from '@ohos/systemuicommon';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { NormalNotification } from '@ohos/systemuicommon/src/main/ets/model/NormalNotification';

const TAG = 'NotificationMoreHeaderVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COLLAPSE_BUTTON_ENABLE_OPACITY = 0.8;

/**
 * 更多通知头部管理
 *
 * @since 2024-11-26
 */
@ObservedV2
export class NotificationMoreHeaderVm extends NotificationBaseVm implements INotificationMoreHeaderVm {
  /**
   * 是否正在一键删除动效过程中
   */
  @Trace public isInClearAllAnim: boolean = false;
  /**
   * 动效过程中，更多通知头的缩放值
   */
  @Trace public animationScale: number = 0;
  /**
   * 动效过程中，更多通知头的透明度
   */
  @Trace public animationOpacity: number = 0;
  /**
   * 下拉出场动效Y轴偏移量
   */
  public appearTranslateY: number = 0;
  /**
   * 下拉跟手动效Y轴偏移量
   */
  public followTranslateY: number = 0;
  /**
   * Y轴偏移量
   */
  @Trace public translateY: number = 0;

  /**
   * 更多通知文本最大宽度
   */
  @Trace public moreHeaderContentMaxWidth: string = '50%';

  /**
   * 是否折叠, 当更多通知数量小于1时返回不折叠
   */
  @Computed
  get isCollapsed() {
    if (NotificationMoreHeaderModel.instance.isCollapsed) {
      const listVm = this.vmInjector.getListVm();
      if (listVm?.moreNtfList !== undefined) {
        return listVm.moreNtfList.length > 1;
      }
    }
    return NotificationMoreHeaderModel.instance.isCollapsed;
  }

  /**
   * 是否按钮折叠
   */
  @Computed
  get isButtonCollapsed() {
    return NotificationMoreHeaderModel.instance.isCollapsed;
  }

  /**
   * 更多通知折叠展开动效
   */
  private collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();

  /**
   * 更多通知header按钮组件ID
   */
  public readonly moreHeaderButtonId = this.vmInjector.getId(`${TAG}_More_Header_Button`);

  /**
   * 根据第一个更多通知卡片(NTF)的透明度值计算更多通知头(Header)透明度值，按照 Ntf 100%~thr 对应 Header 100%~0%
   * 即：Ntf = 100% 时，Header = 100%; Ntf = thr时，Header = 0%， Ntf (thr,100) 时，Header 按比例取值
   * @returns
   */
  @Computed
  get opacity() {
    const panelVm = this.vmInjector.getPanelVm();
    if (this.isInClearAllAnim) {
      return this.animationOpacity;
    }
    const firstMoreNtf = this.vmInjector.getListVm()!.moreNtfList[0];
    if (firstMoreNtf) {
      // 横屏状态下构造通知，如一条单行通知、一条四行通知、多条不同应用的更多通知 使更多通知标题卡片略微处于堆叠态，调整映射区间使透明度高于0.8
      const thr = panelVm.isLandscapeLayout ? 0.68 : 0.712;
      const firstMoreNtfOpacity = this.vmInjector.getCardVm(firstMoreNtf).opacity;
      return Math.max((firstMoreNtfOpacity - thr) / (1 - thr), 0);
    }
    return 1;
  }

  /**
   * 滑动缩放值
   */
  @Computed
  get scale() {
    if (this.isInClearAllAnim) {
      return this.animationScale;
    }
    const firstMoreNtf = this.vmInjector.getListVm()!.moreNtfList[0];
    if (firstMoreNtf) {
      return this.vmInjector.getCardVm(firstMoreNtf).scale;
    }
    return 1;
  }

  reset(): void {
    const firstMoreNtf = this.vmInjector.getListVm()!.moreNtfList[0];
    if (firstMoreNtf) {
      const cardVm = this.vmInjector.getCardVm(firstMoreNtf);
      this.translateY = cardVm.translateY;
      log.showInfo(`reset moreHeader, is last item, translateY = ${this.translateY}`);
    } else {
      this.translateY = 0;
    }
    this.isInClearAllAnim = false;
    this.animationScale = this.scale;
    this.animationOpacity = this.opacity;
    this.appearTranslateY = 0;
    this.followTranslateY = 0;
  }

  deleteChainAnimation(translateY: number): void {
    log.showInfo(`Update header by delete, translateY:${translateY}`);
    this.translateY = translateY;
  }

  moreHeaderReboundAnimation(translateY?: number): void {
    log.showInfo(`Update moreHeader by item rebound,` +
      ` followTranslateY = ${translateY}, translateY:${this.appearTranslateY + this.followTranslateY}`);

    if (translateY !== undefined) {
      this.followTranslateY = translateY;
      this.translateY = this.appearTranslateY + this.followTranslateY;
    }
  }

  /**
   * 更多通知标题下拉出场动效
   * @param translateY 位移
   */
  moreHeaderAppearAnimation(scale?: number, opacity?: number, translateY?: number): void {
    log.showInfo(`Update moreHeader by appear, scale: ${scale}, opacity: ${opacity},` +
      ` appearTranslateY: ${translateY}, translateY = ${this.appearTranslateY + this.followTranslateY}`);

    if (scale !== undefined) {
      this.animationScale = scale;
    }

    if (opacity !== undefined) {
      this.animationOpacity = opacity;
    }

    if (translateY !== undefined) {
      this.appearTranslateY = translateY;
      this.translateY = this.appearTranslateY + this.followTranslateY;
    }
  }
  /**
   * 更多通知标题下拉跟手动效
   * @param translateY 位移
   */
  moreHeaderFollowAnimation(translateY?: number): void {
    log.showInfo(`Update moreHeader by item follow,` +
      ` followTranslateY = ${translateY}, translateY: ${this.appearTranslateY + this.followTranslateY}`);

    if (translateY !== undefined) {
      this.followTranslateY = translateY;
      this.translateY = this.appearTranslateY + this.followTranslateY;
    }
  }

  /**
   * 更多通知标题一键删除动效
   *
   * @param scale 缩放值
   * @param opacity 透明度
   * @param translateY 位移
   */
  clearAllAnimation(scale?: number, opacity?: number, translateY?: number): void {
    log.showInfo(`Update moreHeader by clear all, scale:${scale}, opacity:${opacity}, translateY:${translateY}`);
    if (scale !== undefined) {
      this.animationScale = scale;
    }
    if (opacity !== undefined) {
      this.animationOpacity = opacity;
    }
    if (translateY !== undefined) {
      this.translateY = translateY;
    }
  }

  /**
   * 折叠收起切换
   *
   * @param isFromBrief 点击事件是否由折叠态更多通知触发，影响无障碍聚焦组件
   */
  toggleCollapsed(isFromBrief: boolean): void {
    // 透明度未到达阈值时不执行展开收起
    if (this.opacity <= COLLAPSE_BUTTON_ENABLE_OPACITY) {
      log.showWarn(`do not execute toggleCollapsed, opacity: ${this.opacity}`);
      return;
    }

    NotificationApiUtil.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    this.updateCollapsedAnimation();
    const moreNtfVm: INotificationMoreVm | undefined = this.vmInjector.getMoreVm();
    if (moreNtfVm) {
      moreNtfVm.isCreatedExtraBriefWhenCollapsed = this.isCollapsed;
      moreNtfVm.isExtraNtfsCollapseStatusChanging = true;
    }
    this.vmInjector.getListVm()?.updateTransparentCardHeight(true);
    const firstExtraNtfDelayTime = (this.vmInjector.getMoreVm()?.getFirstExtraNtfDelayTime()) ?? 0;
    // 使用setTimeout的方式使列表发生进行滚动
    setTimeout(() => {
      this.vmInjector.getListVm()?.updateTransparentCardHeight(false);
    }, firstExtraNtfDelayTime + 250);
    this.collapsedAnimation.doCollapsedAnimation(() => {
      NotificationMoreHeaderModel.instance.isCollapsed = !this.isCollapsed;
      if (!NotificationMoreHeaderModel.instance.isCollapsed) {
        this.vmInjector.getListScrollerVm()?.scrollMoreNtfToBottomIfNeed();
      }
      this.collapsedAccessibilityEvent(isFromBrief);
      log.showInfo(`Content Brief click, status is ${this.isCollapsed}`);
    }, () => {
      if (moreNtfVm) {
        moreNtfVm.isExtraNtfsCollapseStatusChanging = false;
      }
      this.updateZIndex(true);
      NotificationApiUtil.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
    },
      firstExtraNtfDelayTime);
  }

  /**
   * 折叠收起切换无障碍事件
   */
  private collapsedAccessibilityEvent(isFromBrief: boolean): void {
    if (!AccessibilityVm.instance.isEnabled) {
      return;
    }
    // 播报 已收起 已展开
    if (!NotificationMoreHeaderModel.instance.isCollapsed) {
      AccessibilityVm.instance.sendEventByResource($r('app.string.cc_accessibility_str_ntf_swipe_left_text'));
    } else {
      AccessibilityVm.instance.sendEventByResource($r('app.string.cc_accessibility_str_ntf_swipe_right_text'));
    }
    // 主动聚焦
    if (isFromBrief) {
      const listVm = this.vmInjector.getListVm();
      if (listVm && listVm.moreNtfList.length > 0) {
        const firstMoreNtf = listVm.moreNtfList[0];
        AccessibilityVm.instance.requestFocusAccessibility(this.vmInjector.getCardVm(firstMoreNtf)
          .getAccessibilityFocusId(), true);
        return;
      }
    }
    AccessibilityVm.instance.requestFocusAccessibility(this.moreHeaderButtonId, true);
  }

  private updateCollapsedAnimation(): void {
    const endIndex = this.vmInjector.getListScrollerVm()!.endIndex;
    const mainNtfLength = this.vmInjector.getListVm()!.mainNtfList.length;
    const moreNtfList = this.vmInjector.getListVm()!.moreNtfList;
    const animations = this.collapsedAnimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfList.length,
      this.calExtraNtfVisibleCount(mainNtfLength));
    for (let i = 0; i < animations.length; i++) {
      if (moreNtfList[i]) {
        const cardVm = this.vmInjector.getCardVm(moreNtfList[i]);
        cardVm.updateTransitionAnimation(animations[i]);
      }
    }
    this.updateZIndex();
  }

  private calExtraNtfVisibleCount(mainNtfLength: number): number {
    if (!NotificationMoreHeaderModel.instance.isCollapsed) {
      return 0;
    }
    const listScrollerVm = this.vmInjector.getListScrollerVm();
    const extraHeaderRectInfo = listScrollerVm?.scroller.getItemRect(mainNtfLength);
    if (!extraHeaderRectInfo?.height) {
      return 0;
    }
    // 已经占用的高度
    const usedHeight = extraHeaderRectInfo.y + extraHeaderRectInfo.height;
    // 更多通知可使用的高度
    const listId = this.vmInjector.getId('NotificationListComponent');
    const extraNtfHeight =
      SystemUICommonUtil.getRect(listId, ArkUIAdapter.getUiContextByViewName(this.vmInjector.viewName)).height -
        usedHeight;
    const extraNtfVisibleCount = Math.ceil(extraNtfHeight / (this.getExtraNtfMinHeight() + listScrollerVm!.space));
    const extraNtfExpandDefaultShowCount = 3;
    if (extraNtfVisibleCount < extraNtfExpandDefaultShowCount) {
      return extraNtfExpandDefaultShowCount;
    }
    return extraNtfVisibleCount;
  }

  private getExtraNtfMinHeight(): number {
    return ResourceVm.instance.getNumber($r('app.float.single_item_card_margin')) +
      ResourceVm.instance.getFontScale() * ResourceVm.instance.getNumber($r('app.float.ntf_text_line_height')) * 2;
  }

  private updateZIndex(isReset = false): void {
    const moreNtfList = this.vmInjector.getListVm()?.moreNtfList;
    moreNtfList?.forEach((ntf, index) => {
      const cardVm = this.vmInjector.getCardVm(ntf);
      cardVm.zIndex = isReset ? 1 : moreNtfList.length - index;
      log.showInfo(`updateZIndex ${ntf.hashCode}, zIndex: ${cardVm.zIndex}`);
    });
  }

  public collapsedButtonSizeChange = (_: SizeOptions, size: SizeOptions): void => {
    // 20vp为折叠、展开按钮的的 start、end方向的margin值
    this.moreHeaderContentMaxWidth = `calc(100% - 20vp - ${size.width}vp)`;
  };
}