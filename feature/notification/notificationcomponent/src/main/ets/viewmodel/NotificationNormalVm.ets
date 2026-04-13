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

import { AnimationBase,
  INotificationCardVm,
  INotificationNormalVm,
  NotificationItemBaseVm,
  INotificationSwipeVm,
  INotificationTimeVm,
  AccessibilityVm,
} from '@ohos/systemuicommon/newIndex';
import { NormalNotification, SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import { curves, LengthMetrics } from '@kit.ArkUI';
import { NotificationAction } from '@ohos/systemuicommon/src/main/ets/model/NotificationContent';
import { DomainName, LogDomain, LogHelper,
  TraceUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { TextEmojiHelper } from '@ohos/systemuicommon/src/main/ets/utils/TextEmojiHelper';
import { ClickNotificationMaintenance, ClickRegion, NtfMultiLineContent } from '@ohos/systemuicommon';
import { notificationManager } from '@kit.NotificationKit';
import { WantAgent } from '@kit.AbilityKit';

const TAG = 'NotificationNormalVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const ANIMATION_CURVE: ICurve = curves.interpolatingSpring(0, 1, 225, 25);
const LIST_ITEM_TRANSITION_CURVE = curves.interpolatingSpring(0, 1, 228, 28);

/**
 * 普通通知VM
 */
@ObservedV2
export class NotificationNormalVm extends NotificationItemBaseVm<NormalNotification>
implements INotificationNormalVm {
  public readonly componentId = this.vmInjector.getId(`${TAG}_${this.ntf.hashCode}`);
  public readonly bodyComponentId = this.vmInjector.getId(`${TAG}_top_${this.ntf.hashCode}`);
  public readonly titleComponentId = this.vmInjector.getId(`${TAG}_title_${this.ntf.hashCode}`);

  @Trace public static expandActionButtonMap: Map<SystemUIUseScene, string> = new Map();
  public static isActionButtonExpanding: boolean = false;
  @Trace public isReplying: boolean = false;
  @Trace public replayAction?: NotificationAction;
  @Trace public clip: boolean = true;
  @Trace private isAlwaysShowButton: boolean = this.timeVm?.isAlwaysShowButton || false;
  public replayContent: string = '';

  public transition?: TransitionEffect = TransitionEffect.asymmetric(
    TransitionEffect.OPACITY.animation({
      duration: 100,
      curve: LIST_ITEM_TRANSITION_CURVE
    }), TransitionEffect.IDENTITY);

  private hasReportHiEvent: boolean = false;

  @Computed get isPanelVisible(): boolean {
    return this.vmInjector.getPanelVm().isVisible;
  }

  @Computed get isShowActionButton(): boolean {
    return this.isAlwaysShowButton ||
      NotificationNormalVm.expandActionButtonMap.get(this.vmInjector.scene) === this.ntf.hashCode;
  }

  public expandActionButtonAnimation = new AnimationBase(AnimationBase.NAMES.NTF_ACTION_BUTTON_ANIMATION);

  static hideActionButtons(scene: SystemUIUseScene): void {
    if (NotificationNormalVm.expandActionButtonMap.get(scene)) {
      NotificationNormalVm.isActionButtonExpanding = true;
    }
    animateTo({
      curve: ANIMATION_CURVE, onFinish: () => {
        log.showInfo(`Hide action button finished`);
        NotificationNormalVm.isActionButtonExpanding = false;
      }
    }, () => {
      NotificationNormalVm.expandActionButtonMap.set(scene, '');
    })
  }

  @Computed
  get timeMarginStart(): LengthMetrics {
    return LengthMetrics.resource($r('app.float.ntf_item_padding_start_end'));
  }

  @Computed
  get height(): number | undefined {
    return undefined;
  }

  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.vmInjector.getSwipeVm(this.ntf);
  }

  @Computed get timeVm(): INotificationTimeVm | undefined {
    return this.vmInjector.getTimeVm(this.ntf);
  }

  get isShowPinTop(): boolean {
    return this.ntf.isDisplayAtTop;
  }

  get isEmergencyNtf(): boolean {
    return this.ntf.slotType === notificationManager.SlotType.EMERGENCY_INFORMATION;
  }

  onClick(): void {
    log.showInfo(`Click for container ${this.ntf.hashCode}`);
    TraceUtil.startTrace(DomainName.NC, 'NotificationTouchDown');
    if (this.swipeVm?.offsetX !== 0) {
      this.swipeVm?.resetOffsetX(true);
      return;
    }
    if (this.showActionButtons()) {
      return;
    }

    this.getCardVm().onClick(this.ntf);
    TraceUtil.endTrace(DomainName.NC, 'NotificationTouchDown');
  }

  public onInputChange = (value: string): void => {
    this.replayContent = value;
    if (!this.hasReportHiEvent) {
      this.hasReportHiEvent = true;
      HiDfxEventUtil.reportNotificationReplyInputContent(this.ntf.creatorBundleName, this.ntf.id);
    }
  };

  /**
   * 当展示/隐藏通知面板时，重新获取是否始终显示通知按钮
   */
  @Monitor('isPanelVisible')
  onPanelVisibleChange(): void {
    this.isAlwaysShowButton = this.timeVm?.isAlwaysShowButton || false;
  }

  showActionButtons(): boolean {
    if (this.ntf.actionButtons?.length && !this.isShowActionButton) {
      const expandItem = NotificationNormalVm.expandActionButtonMap.get(this.vmInjector.scene);
      if (!expandItem || expandItem !== this.ntf.hashCode) {
        log.showInfo(`Expand action button for ${this.ntf.hashCode}`);
        NotificationNormalVm.isActionButtonExpanding = true;
        this.expandActionButtonAnimation.executeAnimation([{
          curve: ANIMATION_CURVE,
          onFinish: () => {
            log.showInfo(`Expand action button for ${this.ntf.hashCode} finished`);
            NotificationNormalVm.isActionButtonExpanding = false;
          },
          event: () => {
            NotificationNormalVm.expandActionButtonMap.set(this.vmInjector.scene, this.ntf.hashCode);
            AccessibilityVm.instance.requestFocusAccessibility(this.vmInjector.getActionButtonVm(this.ntf)
              .getActionButtonId(0));
          },
        }], this.ntf.hashCode);
        return true;
      }
    }
    return false;
  }

  getCardVm(): INotificationCardVm {
    return this.vmInjector.getCardVm(this.ntf);
  }

  /**
   * 获取通知标题
   *
   * @return 标题
   */
  @Computed public get ntfTitle(): ResourceStr {
    if (this.ntf?.isExpandable) {
      // 展开title
      return this.getExpandedTitle();
    }
    // 没有标题或内容时设置为应用名称
    if (!this.ntf?.content?.contentTitle || !this.ntf?.content?.contentText) {
      return this.ntf?.appLabel ?? ' ';
    }
    return this.ntf.content.contentTitle ?? ' ';
  }

  private getExpandedTitle(): string {
    if (this.isMultiLineEmpty()) {
      // 没有通知内容显示应用名称
      return this.ntf?.appLabel;
    }
    return this.ntf?.content?.expandedTitle;
  }

  private isMultiLineEmpty(): boolean {
    if (this.ntf.contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE) {
      const linesText = (this.ntf?.content as NtfMultiLineContent)?.linesText ?? [];
      return !linesText.some(text => text);
    }
    return false;
  }

  /**
   * 获取通知内容
   *
   * @return 内容
   */
  @Computed public get ntfContent(): string {
    if (this.isMultiLineEmpty()) {
      return this.ntf?.content?.contentTitle;
    }
    if (this.ntf?.isExpandable) {
      return this.ntf?.content?.expandedContentText;
    }
    // 没有通知内容时设置为通知标题
    if (!this.ntf?.content?.contentText) {
      return this.ntf?.content?.contentTitle ?? ' ';
    }
    return this.ntf.content.contentText ?? ' ';
  }

  /**
   * 是否使用RenderGroup
   */
  @Computed
  get isRenderGroup(): boolean {
    let textItem = this.ntfContent;
    if (textItem) {
      return Array.isArray(textItem) ? !textItem.some(TextEmojiHelper.isEmoji) : !TextEmojiHelper.isEmoji(textItem);
    }
    return true;
  }

  /**
   * 校验榜单置顶通知多行文本内容是否非空
   *
   * @returns true:非空; false:空
   */
  linesTextIsValid(): boolean {
    if (!this.ntf || !this.ntf.content) {
      log.warn(`ntf or ntf.content is null`);
      return false;
    }
    if (!(this.ntf.content instanceof NtfMultiLineContent)) {
      log.warn(`ntf.content is not instanceof NtfMultiLineContent`);
      return false;
    }
    let multiLineContent = this.ntf.content as NtfMultiLineContent;
    if (!multiLineContent.linesText || multiLineContent.linesText.length === 0) {
      log.warn(`multiLineContent.linesText is empty`);
      return false;
    }
    return true;
  }

  /**
   * 判断热榜内容是否包含emoji表情字符
   *
   * @returns true:包含;false:不包含
   */
  hasEmojiInMultiLines(): boolean {
    if (!this.linesTextIsValid()) {
      return false;
    }
    let multiLineContent = this.ntf.content as NtfMultiLineContent;
    return multiLineContent.linesText.some(TextEmojiHelper.isEmoji);
  }

  /**
   * 点击热榜内容
   *
   * @param title 热榜内容条目
   * @param index 热榜内容条目索引
   */
  async onClickMultiContent(title: string, index?: number): Promise<void> {
    if (!this.linesTextIsValid()) {
      this.onClick();
      return;
    }

    if (index === undefined || index === null) {
      log.showInfo(`onClickMultiContent index is undefined or null`);
      this.onClick();
      return;
    }

    /*let ntfMultiLineContent: NtfMultiLineContent = this.ntf.content as NtfMultiLineContent;
    if (ntfMultiLineContent.lineWantAgents && index >= 0 && index < ntfMultiLineContent.lineWantAgents.length) {
      log.showInfo(`onClickMultiContent:${title}, ${index}`);
      let contentWantAgent = ntfMultiLineContent.lineWantAgents[index];
      if (contentWantAgent) {
        this.startMultiContentWantAgent(contentWantAgent);
      } else {
        log.warn(`onClickMultiContent wantAgent invalid, index${index}`);
        this.onClick();
      }
    } else {
      log.showInfo(`onClickMultiContent no lineWantAgents, index:${index}`);
      // default
      this.onClick();
    }*/
  }

  /**
   * 拉起热榜内容页
   *
   * @param contentWantAgent 热榜内容WantAgent
   */
  private startMultiContentWantAgent(contentWantAgent: WantAgent): void {
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.NTF_MAIN,
    });

    const groupNtf = this.vmInjector.getListVm()?.getGroupNtf(this.ntf);
    const groupCardVm = groupNtf ? this.vmInjector.getCardVm(groupNtf) : undefined;

    this.vmInjector.getStarterVm().startWantAgent({
      groupNtf,
      groupCardVm,
      cardVm: this.vmInjector.getCardVm(this.ntf),
      wantAgent: contentWantAgent,
      triggerInfo: { code: 0 },
    });
  }
}