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

import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  AccessibilityVm,
  DropdownVm,
  INotificationCardVm,
  NotificationItemBaseVm
} from '@ohos/systemuicommon/newIndex';
import {
  LiveNotification,
  NormalNotification,
  NormalNotificationGroup, NotificationBase, NotificationCategory } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../common/NotificationConfig';
import {
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { curves } from '@kit.ArkUI';
import { AppProtectedStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedStatusVm';
import { ClickNotificationErrorCode } from '@ohos/systemuicommon';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { NotificationConstants } from '../common/NotificationConstants';
import { NotificationNormalVm } from './NotificationNormalVm';
import {
  NotificationCardFloatingWantAgentParams
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationCardFloatingVm';
import { NTF_BRIGHTENS_CENTRALIZED } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import {
  NotificationMoreHeaderModel
} from '@ohos/systemuicommon/src/main/ets/notification/model/NotificationMoreHeaderModel';

const TAG = 'NotificationCardVm';
const log: Logger = Logger.getLogHelper(LogDomain.NC);
const LIST_ITEM_TRANSITION_CURVE = curves.interpolatingSpring(0, 1, 228, 28);
const NTF_CARD_SCALE_CURVE = curves.interpolatingSpring(10, 1, 350, 35);
const CLIP_HEIGHT = 50;
const MORE_BRIEF_TAG = 'NotificationMoreBriefView';
const PRIVACY_VIEW_TAG = 'NotificationPrivacyView';

/**
 * 通知卡片管理
 *
 * @since 2024-11-25
 */
@ObservedV2
export class NotificationCardVm extends NotificationItemBaseVm implements INotificationCardVm {
  public static readonly cardAnim: TransitionEffect = TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
    duration: 167,
    delay: 83,
    curve: LIST_ITEM_TRANSITION_CURVE
  }).combine(TransitionEffect.opacity(0)).combine(TransitionEffect.scale({ x: 0.6, y: 0.6 })),
    TransitionEffect.OPACITY.combine(TransitionEffect.scale({
      x: 0.6,
      y: 0.6,
      centerX: '50%',
      centerY: 0
    })).animation({ duration: 100, curve: LIST_ITEM_TRANSITION_CURVE }));
  public readonly componentId: string = this.vmInjector.getId(`${TAG}_${this.ntf.hashCode}`);
  /**
   * 是否正在一键删除动效过程中
   */
  @Trace public isInClearAllAnim: boolean = false;
  /**
   * 是否正在下拉动效过程中
   */
  @Trace public isInAppearAnim: boolean = false;
  /**
   * 滑动缩放值
   */
  @Trace public scale: number = 1;
  /**
   * 按压缩放值
   */
  @Trace public itemClickScale: number = 1;
  /**
   * 缩放Y轴中心
   */
  @Trace public scaleCenterY: string = '50%';
  /**
   * 透明度
   */
  @Trace public opacity: number = 1;
  /**
   * Y轴偏移量
   */
  @Trace public translateY: number = 0;
  /**
   * 卡片转场动效
   */
  @Trace public transitionAnimation: TransitionEffect = TransitionEffect.OPACITY.combine(TransitionEffect.scale({
    x: 0.6,
    y: 0.6,
    centerX: '50%',
    centerY: 0
  })).animation({ duration: 167, curve: LIST_ITEM_TRANSITION_CURVE });
  /**
   * 组通知只有一张卡片时收起动效
   */
  @Trace public singleCardCollapseAnimation: TransitionEffect = TransitionEffect.OPACITY.combine(
    TransitionEffect.scale({
      y: 0.6,
      centerY: 0
    })).animation({ duration: 100, curve: LIST_ITEM_TRANSITION_CURVE });
  /**
   * 圆角裁剪
   */
  @Trace public contentClipParam: boolean | RectAttribute = true;
  /**
   * 圆角裁剪
   */
  @Trace public containerClip: boolean | RectAttribute = true;
  /**
   * 卡片内容对齐方式
   */
  @Trace public align: Alignment = Alignment.End;
  /**
   * 卡片ZIndex，一镜到底动效时需要使用
   */
  @Trace public zIndex: number = 1;
  /**
   * 卡片容器尺寸，一镜到底动效时需要使用
   */
  @Trace public containerSize?: SizeOptions;
  /**
   * 卡片内容尺寸，一镜到底动效时需要使用
   */
  @Trace public contentSize: SizeOptions = { width: '100%', height: 'auto' };
  /*
   * 是否是成组场景
   */
  @Trace public isSaveGroupNtf: boolean = false;
  /*
   * 是否展示组通知卡片
   */
  @Trace public showGroup: boolean = this.ntf.isNormalGroup() ? true : false;
  /**
   * 是否需要设置卡片手势
   */
  public needGesture: boolean = true;
  /**
   * 卡片高度
   */
  public height: number = 0;
  /**
   * 是否正在触摸通知卡片
   */
  public isTouching?: boolean = false;
  /**
   * 触摸时的手指的X坐标
   */
  private touchStartX: number = 0;
  /**
   * 触摸式手指的Y坐标
   */
  private touchStartY: number = 0;

  @Computed
  get contentId(): string {
    return this.vmInjector.getId(`${TAG}_content_${this.ntf.hashCode}`);
  }

  @Computed
  get cardBgColor(): ResourceColor | undefined {
    const colorVm = this.vmInjector.getColorVm();
    if (colorVm.isBrightnessEffect && NTF_BRIGHTENS_CENTRALIZED) {
      return undefined;
    }
    return this.ntf.isLiveView() ? colorVm.ntfLiveCardBgColor : colorVm.ntfCardBgColor;
  }

  @Computed
  get cardBgBrightness(): BrightnessOptions | undefined {
    const colorVm = this.vmInjector.getColorVm();
    if (colorVm.isBrightnessEffect && NTF_BRIGHTENS_CENTRALIZED) {
      return undefined;
    }
    return this.ntf.isLiveView() ? colorVm.cardLiveBgBrightness : colorVm.cardBgBrightness;
  }

  @Computed
  get cardEnable(): boolean {
    return this.opacity >= 0.8;
  }

  @Computed
  get accessibilityDescription(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }

    const menuVm = this.vmInjector.getMenuVm(this.ntf)
    if (menuVm?.isShowSettingButton() || menuVm?.isShowRemoveButton()) {
      return this.vmInjector.getSwipeVm(this.ntf)?.getSwipeAccessibilityDescription() ?? '';
    }

    return !this.ntf.wantAgent ? ' ' : '';
  }

  /**
   * 通知是否处于保护状态
   * @returns
   */
  @Computed
  get isPrivacy(): boolean {
    if (this.ntf.isLiveView()) {
      return false;
    }
    return AppProtectedStatusVm.instance.isProtected(this.ntf.creatorBundleName, this.ntf.appIndex);
  }

  /**
   * 卡片宽度
   */
  @Computed
  get cardWidth(): number | string {
    return this.vmInjector.getPanelVm().cardWidth;
  }

  /**
   * 标题文本颜色
   */
  @Computed
  get titleFontColor(): ResourceColor | undefined {
    return $r('app.color.theme_ntf_color_text_primary');
  }

  /**
   * 内容文本颜色
   */
  @Computed
  get textFontColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm().fontColor;
  }

  /**
   * 内容文本字体前景提亮参数
   */
  @Computed
  get fontFgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().fontFgBrightness;
  }

  /**
   * 置顶文本颜色
   *
   * @returns 置顶文本颜色
   */
  @Computed
  get pinTopTextColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm()?.pinTopTextColor;
  }

  /**
   * 置顶文本提亮参数
   *
   * @returns 置顶文本提亮参数
   */
  @Computed
  get pinTopFgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm()?.timeFgBrightness;
  }

  /**
   * 普通通知时间文本可见性
   */
  @Computed
  get ntfTimeVisibility(): Visibility | undefined {
    return Visibility.Visible;
  }

  /**
   * 获取通知卡片是否启用useEffect
   *
   * @returns boolean 判断纯色模式、主题是否启用
   */
  @Computed
  get isUseEffect(): boolean {
    const colorVm = this.vmInjector.getColorVm();
    if (colorVm.isThemeActive) {
      return true;
    }
    if (colorVm.isSolidEnable()) {
      return false;
    }
    return true;
  }

  @Monitor('opacity')
  onOpacityChange(): void {
    this.cardClip();
  }

  public onSizeChange = (_: SizeOptions, size: SizeOptions): void => {
    log.showInfo(TAG, `On size change for ${this.ntf.hashCode}, height: ${size.height}`);
    this.height = size.height as number;
    this.onOpacityChange();
  };

  /**
   * 重置ListItem的属性
   * 列表滑动时会触发多个item调用，注意赋值会不会导致性能问题。（contentSize只在一镜到底中处理即可，这里赋值会导致冗余绘制）
   */
  reset(): void {
    this.scale = 1;
    this.opacity = 1;
    this.translateY = 0;
    this.contentClipParam = true;
    this.zIndex = 1;
    this.containerSize = undefined;
    this.scaleCenterY = '50%';
    this.isInClearAllAnim = false;
  }

  /**
   * 通知卡片滑动堆叠
   *
   * @param scale 缩放
   * @param opacity 透明度
   * @param translateY 位移
   */
  scrollListItem(scale: number, opacity: number, translateY: number, zIndex: number): void {
    this.scale = scale;
    this.opacity = opacity;
    this.translateY = translateY;
    this.zIndex = zIndex ?? 0;
  }

  /**
   * 通知卡片圆角裁切
   */
  setItemClipParam(clipHeight?: number, clipOffset?: number): void {
    if (!this.ntf) {
      this.contentClipParam = false;
      return;
    }
    if (clipHeight && clipHeight > 0) {
      this.contentClipParam = new Rect({
        width: '100%',
        height: clipHeight,
        radius: NotificationConfig.BORDER_RADIUS,
      }).position({ y: clipOffset });
      return;
    }
    this.contentClipParam = true;
  }

  /**
   * 通知卡片点击
   *
   * @param ntf 被点击的通知信息
   */
  public onClick = (ntf?: NotificationBase): void => {
    this.onItemClick(ntf);
  };

  /**
   * 一键删除动效
   *
   * @param scale 缩放值
   * @param opacity 透明度
   * @param translateY 位移
   */
  clearAllAnimation(scale?: number, opacity?: number, translateY?: number): void {
    log.showInfo(TAG, `Update item ${this.ntf.hashCode} by clear all, scale:${scale},` +
      ` opacity:${opacity}, translateY:${translateY}`);
    if (scale !== undefined) {
      this.scale = scale;
    }
    if (opacity !== undefined) {
      this.opacity = opacity;
    }
    if (translateY !== undefined) {
      this.translateY = translateY;
    }
  }

  /**
   * 通知item依次出场动效
   * @param scale 缩放值
   * @param opacity 透明度
   */
  itemAppearAnimation(scale?: number, opacity?: number, translateY?: number): void {
    log.showInfo(TAG, `Update item ${this.ntf?.hashCode} by item appear, scale: ${scale}, opacity: ${opacity},` +
      ` translateY: ${translateY}`);

    if (scale !== undefined) {
      this.scale = scale;
    }
    if (opacity !== undefined) {
      this.opacity = opacity;
    }
    if (translateY !== undefined) {
      this.translateY = translateY;
    }
  }

  /**
   * 是否为折叠态的更多通知
   *
   * @param index 通知索引值
   * @returns 判断结果
   */
  isMoreBrief(): boolean {
    const isCollapsed = this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed ?? false;
    return this.ntf.isMoreNtf() && isCollapsed;
  }

  /**
   * 更新通知卡片转场动效
   *
   * @param animation 转场动效
   */
  updateTransitionAnimation(animation: TransitionEffect): void {
    this.transitionAnimation = animation;
  }

  /**
   * 获取通知卡片转场动效
   *
   * @returns 动效参数
   */
  getTransitionAnimation(): TransitionEffect {
    if (((this.ntf as NormalNotificationGroup).children ?? []).length === 1) {
      return this.singleCardCollapseAnimation;
    }
    if (!this.vmInjector.getPanelVm().isVisible || this.isSaveGroupNtf) {
      return TransitionEffect.IDENTITY;
    }
    if (this.ntf.isMoreNtf()) {
      const isCollapsed = this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed;
      return isCollapsed ? TransitionEffect.IDENTITY : this.transitionAnimation;
    }
    return NotificationCardVm.cardAnim;
  }

  /**
   * 删除通知前将卡片高度设置为0
   */
  changeNtfHeight2Zero(): void {
    animateTo({ duration: 0 }, () => {
      this.containerSize = { height: 0 }
    })
  }

  /**
   * 删除链式补位动效
   *
   * @param translateY 位移值
   * @param scale 缩放
   * @param opacity 透明度
   */
  deleteChainAnimation(translateY: number, scale?: number, opacity?: number): void {
    log.showInfo(TAG, `Update item ${this.ntf.hashCode} by delete ntf, translateY:${translateY}`);
    this.translateY = translateY;
    if (scale !== undefined) {
      this.scale = scale;
    }
    if (opacity !== undefined) {
      this.opacity = opacity;
    }
  }

  /**
   * 卡片scroll划出后设置为透明，避免后续出现时处理堆叠裁切导致显示跳变
   */
  setItemScrollHide(): void {
    this.opacity = 0;
  }

  /**
   * 卡片触摸事件
   *
   * @param event 触摸事件
   */
  onTouch(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      this.isTouching = true;
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;

      let isGroupExpanded = false;
      const groupNtf = this.vmInjector.getListVm()?.getGroupNtf(this.ntf);
      if (groupNtf) {
        isGroupExpanded = this.vmInjector.getNormalGroupVm(groupNtf)?.isExpanded ?? false;
      }
      animateTo({ curve: NTF_CARD_SCALE_CURVE }, () => this.itemClickScale = isGroupExpanded ? 0.98 : 0.95)
      return;
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.isTouching = false;
      animateTo({ duration: 200, curve: Curve.Linear, }, () => this.itemClickScale = 1);
      return;
    }
    if (event.type === TouchType.Move) {
      // 提高触摸按压状态结束的阈值，避免无意识的轻微移动导致按压态结束
      const isNeedResetScale = Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
        Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4;
      if (this.itemClickScale !== 1 && isNeedResetScale) {
        animateTo({ duration: 200, curve: Curve.Linear, }, () => this.itemClickScale = 1);
      }
    }
  }

  /**
   * 通知卡片点击，提取函数供子类重写
   */
  protected async onItemClick(ntf?: NotificationBase): Promise<void> {
    let wantId: number | undefined = undefined;
    if (this.ntf.wantAgent) {
      wantId = Reflect.get(this.ntf.wantAgent, 'innerKey');
    }
    log.showInfo(TAG, `Click item: ${this.ntf.hashCode}, wantId: ${wantId}`);

    // 左滑显示的卡片点击时，重置回原位置
    const swipeVm = this.vmInjector.getSwipeVm(this.ntf);
    if (swipeVm?.offsetX !== 0) {
      swipeVm?.resetOffsetX(true);
      return;
    }

    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.NTF_MAIN,
    });

    const floatingVm = this.vmInjector.getCardFloatingVm(this.ntf);
    const params: NotificationCardFloatingWantAgentParams = {
      wantAgent: ntf?.wantAgent,
      wantAgentInfo: ntf?.wantAgentInfo,
    };
    if (await floatingVm.canOpenFloating(params)) {
      floatingVm.startFloatingForClick(params);
      DropdownVm.instance.hidePanel(true);
      return;
    }

    const groupNtf = this.vmInjector.getListVm()?.getGroupNtf(ntf ?? this.ntf);
    const groupCardVm = groupNtf ? this.vmInjector.getCardVm(groupNtf) : undefined;

    this.vmInjector.getStarterVm().startWantAgent({
      groupNtf,
      groupCardVm,
      cardVm: this,
      wantAgent: ntf?.wantAgent ?? this.ntf.wantAgent,
      wantAgentInfo: this.ntf.wantAgentInfo,
      triggerInfo: { code: 0 },
    });
  }

  /**
   * 当通知堆叠的时候，对通知卡片进行裁剪，防止通知卡片从两个通知缝隙中露出
   */
  protected cardClip(): void {
    if (this.isInClearAllAnim) {
      return;
    }
    if (this.checkIsNoNeedClipCard()) {
      this.containerClip = true;
      return;
    }
    if (this.translateY < 0 && this.opacity < 1) {
      // 裁剪底部卡片
      const clipHeight: number = Math.min(this.height + this.translateY + CLIP_HEIGHT, this.height);
      this.containerClip = new Rect({
        width: '100%',
        height: clipHeight,
        radius: NotificationConfig.BORDER_RADIUS,
      }).position({ y: clipHeight === this.height ? 0 : -this.translateY - CLIP_HEIGHT });
    }
  }

  private checkIsNoNeedClipCard(): boolean {
    if (this.translateY === 0 || this.opacity >= 1 || !this.height) {
      return true;
    }
    if (this.ntf.isMoreNtf() || this.isMoreBrief()) {
      return true;
    }
    return false;
  }

  /**
   * 获取卡片背景颜色
   */
  getCardBgColor(): ResourceColor | undefined {
    return this.cardBgColor;
  }

  /**
   * 根据组件Id获取组件一镜到底动效Id，用于组通知header和单通知共用组件一镜到底场景
   *
   * @param componentId
   * @return componentGeometryId
   */
  getComponentGeometryId(componentId: string): string {
    let isMore = this.ntf.isMoreNtf() ? NotificationConstants.NTF_MORE_SUFFIX : NotificationConstants.NTF_MAIN_SUFFIX;
    if (this.ntf.isNormalGroup() && this.ntf.children.length > 0) {
      return this.ntf.children[0].key + componentId + this.vmInjector.scene + isMore;
    }
    return this.ntf.key + componentId + this.vmInjector.scene + isMore;
  }

  /**
   * 通知条目是否处于侧滑
   *
   * @returns true 处于侧滑
   */
  isSwiped(): boolean {
    return this.vmInjector.getSwipeVm(this.ntf)?.offsetX !== 0;
  }

  /**
   * 判断手势拦截
   */
  onGestureJudgeBegin(info: GestureInfo): GestureJudgeResult {
    return GestureJudgeResult.CONTINUE;
  }

  /**
   * 获取更多通知zIndex
   * @param index
   * @returns
   */
  getMoreNtfZIndex(index: number): number {
    // 排列越后的通知卡片zIndex越小
    return this.zIndex - index;
  }

  /**
   * 卡片出场重置ListItem部分属性，其他属性由出场动效赋值
   */
  itemAppearReset(): void {
    this.contentClipParam = true;
    this.zIndex = 1;
    this.containerSize = undefined;
    this.scaleCenterY = '50%';
    this.isInClearAllAnim = false;
    this.containerClip = true;
  }

  /**
   * 获取通知卡片无障碍主动聚焦组件Id
   *
   * @returns compId 主动聚焦的组件Id
   */
  getAccessibilityFocusId(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    if (NotificationMoreHeaderModel.instance.isCollapsed && this.ntf.isMoreNtf()) {
      return this.vmInjector.getId(MORE_BRIEF_TAG);
    }
    if (this.isPrivacy) {
      return this.vmInjector.getId(`${PRIVACY_VIEW_TAG}_${this.ntf.hashCode}`)
    }
    if (this.ntf instanceof LiveNotification) {
      return this.contentId;
    }
    if (this.ntf instanceof NormalNotification){
      return this.vmInjector.getNormalVm(this.ntf).componentId;
    }
    if (this.ntf instanceof NormalNotificationGroup) {
      return this.vmInjector.getNormalGroupVm(this.ntf)?.componentId ?? '';
    }
    return '';
  }
}