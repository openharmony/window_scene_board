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
import { LogDomain, Logger } from '@ohos/basicutils';
import { AnimationBase,
  INotificationBannerVm,
  INotificationCardVm, INotificationImmersiveVm,
  NotificationBaseVm,
  NOTIFICATION_ICON_SMALL_SCALE, ResourceVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { curves, MeasureText } from '@kit.ArkUI';
import { notificationManager } from '@kit.NotificationKit';
import { SystemUICommonUtil } from '@ohos/systemuicommon';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'NotificationImmersiveVm';
const log: Logger = Logger.getLogHelper(LogDomain.NC);
const APP_ICON_WIDTH = 24;
const SPACE = 8;
const EXPAND_ICON_WIDTH = 24;
const PADDING = 12;

@ObservedV2
export class NotificationImmersiveVm extends NotificationBaseVm implements INotificationImmersiveVm {
  @Trace public title: ResourceStr = '';
  @Trace public content: ResourceStr = '';
  @Trace public iconScale: number = 0;
  @Trace public contentOpacity: number = 0;
  @Trace public cardHeight?: number | string = undefined;
  @Trace public titleWidth: number | undefined;
  @Trace public isShowExpandIcon: boolean = false;
  @Trace public titleAlignSelf = ItemAlign.Center;
  @Trace public titleTranslate?: TranslateOptions = undefined;

  public readonly titleComponentId = this.vmInjector.getId(`${TAG}_title`);
  public cardInitializeHeight?: number;
  public ntf: NormalNotification = new NormalNotification();
  public verticalSwipeVm = this.vmInjector.getVerticalSwipeVm();

  @Computed get bannerVm(): INotificationBannerVm {
    return this.vmInjector.getBannerVm();
  }

  @Computed get cardVm(): INotificationCardVm {
    return this.vmInjector.getCardVm(this.ntf);
  }

  @Monitor('bannerVm.isHiddenBannerContent', 'bannerVm.isImmersiveExpanded')
  updateImmersiveBanner(): void {
    // 当前非沉浸式卡片时，不更新
    if (!this.bannerVm.isShowImmersive) {
      return;
    }
    this.calcTitleContent();
  }

  public init(ntf: NormalNotification): void {
    log.showInfo(TAG, `Init for ${ntf.hashCode}`);
    this.ntf = ntf;
    this.iconScale = NOTIFICATION_ICON_SMALL_SCALE;
    this.contentOpacity = 1;
    this.titleAlignSelf = ItemAlign.Center;
    this.titleTranslate = undefined;
    this.cardHeight = undefined;
    this.titleWidth = undefined;
    this.content = '';
    this.calcTitleContent();
  }

  public onClick = (): void => {
    log.showInfo(TAG, `Click for ${this.ntf.hashCode}`);
    // 如果有展开按钮就展开沉浸态卡片
    if (this.isShowExpandIcon) {
      this.expandToCard();
      return;
    }
    // 否则触发卡片整体的点击事件
    this.vmInjector.getBannerVm().onClick();
  };

  public onSizeChange = (_: SizeOptions, size: SizeOptions): void => {
    log.showInfo(TAG, `On size change for ${this.ntf.hashCode}, height: ${size.height}`);
    this.cardInitializeHeight = size.height as number;
  };

  /**
   * 展开沉浸态卡片
   */
  public async expandToCard(): Promise<void> {
    const normalVm = this.vmInjector.getNormalVm(this.ntf);
    const animation = new AnimationBase(AnimationBase.NAMES.NTF_EXPAND_IMMERSIVE, true);
    const normalBodyHeight = SystemUICommonUtil.getRect(normalVm.bodyComponentId).height;
    const normalTitleWidth = SystemUICommonUtil.getRect(normalVm.titleComponentId).width;
    const immersiveTitleWidth = SystemUICommonUtil.getRect(this.titleComponentId).width;

    log.showInfo(TAG, `Expand immersive to card, normalBodyHeight: ${normalBodyHeight}, ` +
      `normalTitleWidth: ${normalTitleWidth}, immersiveTitleWidth: ${immersiveTitleWidth}`);
    animation.setInitialState(() => {
      this.bannerVm.isImmersiveExpanded = true;
      this.titleAlignSelf = ItemAlign.Start;
      this.titleTranslate = { y: 2 };
      if (normalTitleWidth < immersiveTitleWidth) {
        this.titleWidth = normalTitleWidth;
      }
      this.cardVm.containerSize = { height: this.cardInitializeHeight, width: '100%' };
      this.cardVm.position = undefined;
      this.cardVm.opacity = 1;
      normalVm.bodyOpacity = 0;
      normalVm.isExpandImmersive = true;
      normalVm.timeTranslate = { y: 22 };
      normalVm.contentTranslate = { x: 10, y: -22 };
    });
    await animation.executeAnimation([
      {
        duration: 333,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
        event: () => {
          this.cardHeight = normalBodyHeight;
          this.iconScale = 1;
          this.titleTranslate = { y: 4 };
          this.cardVm.containerSize = undefined;
          normalVm.contentTranslate = undefined;
        }
      },
      {
        duration: 118,
        delay: 50,
        curve: curves.cubicBezierCurve(0.2, 0, 0.83, 1),
        event: () => {
          this.contentOpacity = 0;
          normalVm.timeTranslate = undefined;
        }
      },
      {
        duration: 118,
        delay: 90,
        curve: curves.cubicBezierCurve(0.2, 0, 0.83, 1),
        event: () => {
          normalVm.bodyOpacity = 1;
        }
      }
    ]);

    this.bannerVm.isShowImmersive = false;
    this.cardVm.containerSize = undefined;
    normalVm.isExpandImmersive = false;
  };

  /**
   * 获取标题长度
   * 如果标题长度小于组件除去内容的长度，则按标题本身长度截断，内容正常展示。反之，组件长度截断，标题末尾用省略号表示，内容不展示
   */
  public calcTitleContent(): void {
    let content: ResourceStr;

    if (this.bannerVm.isHiddenBannerContent) {
      this.title = this.ntf.appLabel;
      content = ResourceVm.instance.getPluralString($r('app.plural.ntf_hide_content_count'), 1);
    } else if (this.bannerVm.isImmersiveExpanded) {
      this.title = this.ntf?.content?.expandedTitle;
      content = this.ntf.content?.contentText ?? '';
    } else {
      this.title = this.ntf.content?.contentTitle ?? this.ntf.appLabel;
      content = this.ntf.content?.contentText ?? '';
    }
    this.isShowExpandIcon = this.isNeedExpandIcon();

    const titleWidth = this.getTextWidth(this.title, FontWeight.Medium);
    const contentWidth = content ? this.getTextWidth(content, FontWeight.Regular) + SPACE : 0;
    // 剩余可用宽度，总宽度 - 左右padding - 应用图标宽度 - 应用图标与标题间的空隙
    let availableWidth = this.bannerVm.bannerWidth - PADDING * 2 - APP_ICON_WIDTH - SPACE;
    // 如果需要显示展开按钮则减去展开按钮宽度和一个空隙的宽度
    if (this.isShowExpandIcon || titleWidth + contentWidth > availableWidth) {
      this.isShowExpandIcon = true;
      availableWidth -= EXPAND_ICON_WIDTH + SPACE;
    }
    // 如果剩余空间可以放下标题，则标题宽度确定，剩下的可用宽度用来尝试显示内容
    if (availableWidth >= titleWidth) {
      availableWidth -= titleWidth;
      const contentWidth = availableWidth - this.getTextWidth('...', FontWeight.Regular) - SPACE;
      // 如果可用宽度超过省略号的宽度则显示内容，否则会出现内容区仅有一个...的情况不好看
      if (contentWidth > 0) {
        this.content = content;
      } else {
        // 可用长度不足以显示标题时，刷新content。否则出现图标错位
        this.content = '';
      }
    } else {
      this.content = '';
    }

    log.showInfo(TAG, `Calc show content: ${!!this.content}, isShowExpandIcon: ${this.isShowExpandIcon}`);
  }

  public getTextWidth(textContent: string | Resource | undefined, fontWeight: FontWeight): number {
    const size = MeasureText.measureTextSize({
      textContent: textContent,
      maxLines: 1,
      overflow: TextOverflow.Ellipsis,
      fontWeight: fontWeight,
      fontSize: $r('app.float.ntf_title_font_size'),
      lineHeight: $r('app.float.ntf_text_line_height'),
    });
    return ArkUIAdapter.px2vp(size.width as number);
  }

  /**
   * 是否需要显示展开按钮
   * @returns
   */
  public isNeedExpandIcon(): boolean {
    // 应用锁保护 | 智能提醒隐藏 时，不显示展开按钮
    if (this.bannerVm.isHiddenBannerContent) {
      return false;
    }
    // 有按钮需要显示展开按钮
    if (this.ntf.actionButtons?.length) {
      return true;
    }
    // 通知携带图片时，显示展开按钮
    if (this.ntf.largeIcon) {
      return true;
    }
    // 非单行文本需要显示展开按钮
    if (this.ntf.contentType !== undefined &&
      this.ntf.contentType !== notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT) {
      return true;
    }
    return false;
  }

  reset(): void {
    this.cardHeight = undefined;
  }
}