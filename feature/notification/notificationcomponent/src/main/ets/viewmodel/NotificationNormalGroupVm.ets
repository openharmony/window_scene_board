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

import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NormalNotification, NormalNotificationGroup } from '@ohos/systemuicommon/newTsIndex';
import {
  AccessibilityVm,
  AnimateParams,
  AnimationBase,
  INotificationCardVm,
  INotificationNormalGroupVm,
  INotificationSwipeVm,
  NotificationItemBaseVm,
  DropDownPanelManager
} from '@ohos/systemuicommon/newIndex';
import { NotificationGroupExpandedAnimation } from '../animation/NotificationGroupExpandedAnimation';
import { NotificationNormalVm } from './NotificationNormalVm';
import curves from '@ohos.curves';
import { FrameCount, NotificationSysEventReporter } from '@ohos/systemuicommon';
import { TextEmojiHelper } from '@ohos/systemuicommon/src/main/ets/utils/TextEmojiHelper';
import { UpdateType } from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationListVm';
import { Trace as PerfTrace } from '@ohos/basicutils';
import { NotificationType } from '@ohos/systemuicommon/Index';

const TAG = 'NotificationNormalGroupVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * 组通知展示通知数量
 */
const MAX_SHOW_NTF_NUM = 3;

@ObservedV2
export class NotificationNormalGroupVm extends NotificationItemBaseVm implements INotificationNormalGroupVm {
  /**
   * 是否展开
   */
  @Trace public isExpanded: boolean = false;
  /**
   * 是否摘要文本需要过渡效果
   */
  @Trace public isBriefContentTransition: boolean = false;

  @Trace public frameIndex: number = 0;

  /**
   * 是否隐藏通知内容
   */
  public isHideNtfContent: boolean = false;
  /**
   * 通知隐藏内容
   */
  public hideText: string = '';
  /**
   * 子通知数组
   */
  @Trace public children: NormalNotification[] = (this.ntf as NormalNotificationGroup).children ?? [];
  private anim = new AnimationBase(AnimationBase.NAMES.NTF_GROUP_CHILDREN_UPDATE_ANIMATION, true);

  @Monitor('ntf.children')
  onNtfChildrenChanged(): void {
    if (!this.vmInjector.getPanelVm().isVisible || !this.isExpanded) {
      this.children = (this.ntf as NormalNotificationGroup).children;
    } else {
      this.anim.executeAnimation([{
        duration: 350,
        curve: Curve.Friction,
        event: () => this.children = (this.ntf as NormalNotificationGroup).children
      }])
    }
  }

  /**
   * 剩余通知数量
   */
  @Computed get remainderCount(): string {
    const moreNtfNum = this.children?.length - MAX_SHOW_NTF_NUM;
    if (moreNtfNum > 0) {
      return '+' + moreNtfNum.toString();
    } else {
      return '';
    }
  }

  @Computed get componentId(): string {
    return this.vmInjector.getId(`${TAG}_${this.ntf.hashCode}`);
  }

  @Computed get headerComponentId(): string {
    return this.vmInjector.getId(`${TAG}_${this.ntf.hashCode}_${this.ntf.appIndex}_Header`);
  }

  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.vmInjector.getSwipeVm(this.ntf);
  }

  /**
   * 标题文本颜色
   */
  @Computed get titleFontColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm().ntfThemeTextPrimaryColor;
  }

  /**
   * 内容文本颜色
   */
  @Computed get textFontColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm().ntfThemeTextSecondaryColor;
  }

  /**
   * 内容文本字体前景提亮参数
   */
  @Computed get fontFgBrightness(): BrightnessOptions | undefined {
    return undefined;
  }

  /**
   * 隐藏文本颜色
   *
   * @returns 隐藏文本颜色
   */
  get hideFontColor(): ResourceColor | undefined {
    return $r('app.color.theme_ntf_color_text_primary');
  }

  /**
   * 组通知个数文本颜色
   *
   * @returns 颜色
   */
  @Computed get remainderCountFontColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm()?.ntfRemainderCountTextColor;
  }

  /**
   * 组通知个数文本前景提亮参数
   *
   * @returns 提亮参数
   */
  @Computed get remainderCountFgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm()?.fontFgBrightness;
  }

  /**
   * 组通知个数背景颜色
   *
   * @returns 颜色
   */
  @Computed get remainderCountBgColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm()?.remainderCountColor;
  }

  /**
   * 组通知个数文本背景提亮参数
   *
   * @returns 提亮参数
   */
  @Computed get remainderCountBgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm()?.remainderBgBrightness;
  }

  /**
   * 是否显示时间
   */
  public isShowDateTime: boolean = true;

  /**
   * 折叠态第一条通知Y值
   */
  public briefFirstNtfY: number = 0;
  /**
   * 折叠态图标和第一条通知距离Y值(需要移动的距离)
   */
  public briefIconDiffY: number = 0;
  /**
   * 折叠态图标Y值
   */
  public briefIconY: number = 0;
  /**
   * 分帧处理对象，仅需要记录到第2帧
   */
  public frameCount?: FrameCount;

  /**
   * 动效管理
   */
  private ntfGroupAnimation: NotificationGroupExpandedAnimation = new NotificationGroupExpandedAnimation();

  private cardVm?: INotificationCardVm = this.vmInjector.getCardVm(this.ntf);

  private onFrameCallback = (count: number): void => {
    // 第2帧
    if (count === 2 || count === 3) {
      animateTo({
        duration: 333,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      }, () => {
        this.frameIndex = count;
      });
    }
  }

  public initFrameCount(): void {
    this.frameCount = new FrameCount(this.onFrameCallback);
    // 仅监听前2帧。
    this.frameCount.start(3);
  }

  public isFrameValid(index: number): boolean {
    // 第2帧创建第1~3张卡片
    if (index < 3 && this.frameIndex >= 2) {
      return true;
    }

    // 第3帧创建剩余卡片
    return (this.frameIndex >= 3) ? true : false;
  }

  public onClick(isMenuExpand: boolean): void {
    this.switchExpand(isMenuExpand);
    this.swipeVm?.resetOffsetX(true);
  }

  public switchExpand(isMenuExpand: boolean): void {
    log.showInfo(`Click to switch expand, ${isMenuExpand}, current expand ${this.isExpanded}`);
    this.reportNtfGrouptExpand();
    if (isMenuExpand) {
      return;
    }
    this.isBriefContentTransition = true;
    this.vmInjector.getPanelVm().emitter?.emit('isGroupExpanding', true);
    this.processBeforeExpand();
    this.isExpanded ? TraceUtil.startTrace(DomainName.NC, PerfTrace.CORE_METHOD_FOLD_NOTIFICATION) :
    TraceUtil.startTrace(DomainName.NC, PerfTrace.CORE_METHOD_UNFOLD_NOTIFICATION);
    this.startSwitchExpandAnim({
      duration: NotificationGroupExpandedAnimation.duration,
      curve: NotificationGroupExpandedAnimation.curve,
      event: () => {
        this.onSwitchEvent();
      }
    });
  }

  /**
   * 组通知展开收起打点
   */

  private reportNtfGrouptExpand() {
    NotificationSysEventReporter.notificationFoldGroup({
      OPERATE_METHOD: this.isExpanded ? 1 : 0,
      DISPLAY_SCENE: 4,
      NOTIFICATION_SLOT_TYPE: String(this.ntf?.slotType ),
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      TIME_STAMP:`${DropDownPanelManager.getLastDropdownTime()}`,
    })
  }

  /**
   * 开启组通知折叠展开动效
   *
   * @param anim 动效参数
   */
  protected startSwitchExpandAnim(anim: AnimateParams): void {
    this.ntfGroupAnimation.executeAnimation([anim]).then(() => this.processAfterExpand());
  }

  protected onSwitchEvent() {
    if (this.children?.length === 1) {
      // 组通知变单通知场景，animateTo中改变if的判断条件，实现卡片的一镜到底动效
      if (this.cardVm) {
        this.cardVm.showGroup = false;
      }
      this.vmInjector.getListVm()?.releaseGroup(this.ntf as NormalNotificationGroup);
      this.vmInjector.getListVm()?.updateNtf({ updateType: UpdateType.COLLAPSE });
    } else {
      // 组通知折叠场景
      this.isExpanded = !this.isExpanded;
      if (this.isExpanded) {
        this.vmInjector.getListScrollerVm()?.scrollUpIfNeed(this.ntf);
        this.initFrameCount();
      } else {
        this.frameCount?.reset();
        this.frameCount = undefined;
        this.frameIndex = 0;
      }
    }
    AccessibilityVm.instance.requestFocusAccessibility(this.isExpanded ? this.headerComponentId : this.componentId);
  }

  public updateBriefIconY(y?: Length): void {
    this.briefIconY = y as number ?? this.briefIconY;
    this.updateBriefIconDiffY();
  }

  public updateBriefFirstNtfY(y?: Length): void {
    this.briefFirstNtfY = y as number ?? this.briefFirstNtfY;
    this.updateBriefIconDiffY();
  }

  private processBeforeExpand(): void {
    this.updateNormalViewClip(false);
    NotificationNormalVm.hideActionButtons(this.vmInjector.scene);
  }

  private processAfterExpand(): void {
    this.updateNormalViewClip(true);
    this.isBriefContentTransition = false;
    this.vmInjector.getPanelVm().emitter?.emit('isGroupExpanding', false);
    this.isExpanded ? TraceUtil.endTrace(DomainName.NC, PerfTrace.CORE_METHOD_UNFOLD_NOTIFICATION) :
    TraceUtil.endTrace(DomainName.NC, PerfTrace.CORE_METHOD_FOLD_NOTIFICATION);
  }

  private updateNormalViewClip(isClip: boolean): void {
    for (const ntf of this.children) {
      this.vmInjector.getNormalVm(ntf).clip = isClip;
    }
  }

  private updateBriefIconDiffY(): void {
    const positionY = this.briefFirstNtfY - this.briefIconY;
    if (Math.abs(positionY - this.briefIconDiffY) < Number.EPSILON) {
      return;
    }
    this.briefIconDiffY = positionY;
  }

  public getBriefTextAnimation(index: number): TransitionEffect {
    return this.isBriefContentTransition ? this.ntfGroupAnimation.getBriefTextAnimation(index) :
    TransitionEffect.IDENTITY;
  }

  public getContentTextAnimation(): TransitionEffect {
    return this.ntfGroupAnimation.getContentTextAnimation();
  }

  @Monitor('isExpanded')
  onIsExpandedChange(monitor: IMonitor) {
    if (this.cardVm) {
      this.cardVm.align = monitor.value()?.now === true ? Alignment.TopEnd : Alignment.End;
    }
  }

  public collapseGroup(): void {
    if (this.isExpanded) {
      this.isExpanded = false
    }
  }

  /**
   * 获取组通知标题
   *
   * @return 标题
   */
  public getBriefTitleText(entry: NormalNotification) {
    // 没有标题或内容时设置为应用名称
    if (!entry.content?.contentTitle || !entry.content?.contentText) {
      return this.ntf?.appLabel ?? ' ';
    }
    return entry.content.contentTitle ?? ' ';
  }

  /**
   * 获取组通知内容
   *
   * @return 内容
   */
  public getBriefContentText(entry: NormalNotification): string {
    // 没有通知内容时设置为通知标题
    if (!entry.content?.contentText) {
      return entry.content?.contentTitle ?? ' ';
    }
    return entry.content.contentText ?? ' ';
  }

  /**
   * 是否使用RenderGroup
   */
  public isRenderGroup(textItem: string): boolean {
    if (textItem) {
      return Array.isArray(textItem) ? !textItem.some(TextEmojiHelper.isEmoji) : !TextEmojiHelper.isEmoji(textItem);
    }
    return true;
  }

  /**
   * 子通知是否响应横滑点击事件
   */
  public isChildEnable(): boolean {
    return this.swipeVm?.offsetX === 0
  }

  /**
   * 组通知图标geometryTransition动效Id
   *
   * @returns geometryTransitionId
   */
  public getGeometryTransitionId(): string | undefined {
    const ICON_VIEW_TAG: string = `NotificationIconView`;
    // 只有一条子通知，且子通知存在overlay图标时，组通知标题应用图标转场为littleIcon，否则转场为bigIcon
    const changeToBigIcon: boolean = !(this.children.length === 1 && this.children[0].overlayIcon);
    const suffix: string = changeToBigIcon ? 'bigIcon' : 'littleIcon';
    return `[${this.vmInjector.scene}]${ICON_VIEW_TAG}_${this.children[0].hashCode}_${suffix}`;
  }
}