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
import { ILiveCardNavigationVm } from '../interface/ILiveCardNavigationVm';
import { LiveItemBaseVm } from './LiveBaseVm';
import { LengthMetrics } from '@kit.ArkUI';
import { LiveRichTextModel, LiveTimerModel } from '../model/LiveCommonModel';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveStyle } from '../constants/LiveStyle';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveCardNavigationModel } from '../model/LiveCardNavigationModel';

const TAG = 'LiveCardNavigationVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 导航卡片UI切换参数类型
 */
enum ParamsType {
  DEFAULT = 'default',
  BOTTOM = 'setParamWithBottom',
  NO_NAV_ICONS = 'setParamWithoutNavigationIcons'
}

@ObservedV2
export class LiveCardNavigationVm extends LiveItemBaseVm implements ILiveCardNavigationVm {
  @Computed
  get card(): LiveCardNavigationModel {
    return this.live.card as LiveCardNavigationModel;
  }
  @Trace private paramType: string = ParamsType.DEFAULT;
  @Trace public cardMarginUpperHalf: Padding = {
    top: '9vp',
    bottom: '9vp',
    left: '12vp',
    right: '12vp',
  };
  @Trace public cardMarginBottomHalf: Padding | undefined = undefined
  @Trace public currNavDirectionHeight: string = '48vp';
  @Trace public currNavDirectionWidth: string = '48vp';
  @Trace public mainNavInfoSizeRes: Resource = $r('sys.float.ohos_id_text_size_sub_title3');
  @Computed get mainNavInfoSize(): Length | undefined {
    return ResourceVm.instance.getLiveFontSize(this.mainNavInfoSizeRes);
  }
  public isHideContent(): boolean {
    return false;
  }

  @Computed
  get mainNavInfoWeight(): number | FontWeight | string | undefined {
    if (this.paramType !== ParamsType.DEFAULT) {
      return FontWeight.Bold;
    }
    return FontWeight.Medium;
  }

  @Trace public mainViceSpace?: Resource = $r('sys.float.ohos_id_text_margin_vertical');
  @Trace public viceNavInfoWeight?: FontWeight = FontWeight.Regular;
  @Trace public navInfoMargin: LocalizedPadding = {
    start: LengthMetrics.vp(12),
    end: LengthMetrics.vp(24),
  };
  @Trace public navInfoAlignRule: AlignRuleOption = {
    center: { anchor: '__container__', align: VerticalAlign.Center },
    left: { anchor: `nav-direction-icon_${this.live.hashCode}`, align: HorizontalAlign.End },
    right: { anchor: `nav-app-icon_${this.live.hashCode}`, align: HorizontalAlign.Start },
  };
  @Trace public appIconHeight?: string = '24vp';
  @Trace public appIconWidth?: string = '24vp';
  @Trace public appIconAlignRule: AlignRuleOption = {
    center: { anchor: `nav-direction-icon_${this.live.hashCode}`, align: VerticalAlign.Center },
    right: { anchor: '__container__', align: HorizontalAlign.End },
  };

  @Trace public hasNavDirectionIcons?: boolean = false;
  @Trace public navDirsWidth: number = 0;

  public cardScale?: number = 1;
  public renderGroup: boolean = true;
  public cardMarginTop: Length | undefined = undefined;
  public cardMarginBottom: Length | undefined = undefined;
  public cardMarginHorizontal: Length | undefined = undefined;
  public fontFixedAreaHeight: number = 34;
  @Computed
  get maxFontScale(): number {
    return ResourceVm.instance.getLiveFontScale(ResourceVm.DEFAULT_MAX_SCALE);
  }

  get titleFontColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
  }

  @Computed get imgColorFilter(): ColorFilter | undefined {
    return this.card.layoutNavigationIconMimeType === 'svg' || this.card.layoutNavigationIconMimeType === 'png' ?
      LiveStyle.WHITE_COLOR_FILTER : undefined;
  }

  @Computed get navDirsColorFilter(): ColorFilter | undefined {
    return this.card.layoutNavigationIconMimeType === 'svg' || this.card.layoutNavigationIconMimeType === 'png' ?
      LiveStyle.WHITE_COLOR_FILTER : undefined;
  }
  /*
   * 优先使用图标32，并并套用公式一；当w值<6时，图标向下缩小档位
   * 公式一：w=（卡宽-图标大小*n）/n+1
   */
  @Computed get navDirsSize(): Length {
    if (this.checkNavDirsSize(32)) {
      return '32vp';
    } else if (this.checkNavDirsSize(28)) {
      return '28vp';
    } else {
      return '24vp';
    }
  }

  @Computed
  get mainNavInfoColor(): ResourceColor | undefined {
    return $r('sys.color.ohos_id_color_text_primary');
  }

  @Computed
  get viceNavInfoSize(): Length | undefined {
    if (this.paramType === ParamsType.NO_NAV_ICONS) {
      return $r('sys.float.ohos_id_text_size_sub_title1');
    }
    return $r('sys.float.ohos_id_text_size_body2');
  }

  @Computed
  get viceNavInfoColor(): ResourceColor | undefined {
    return LiveStyle.SYS_TEXT_COLOR_SECONDARY;
  }

  private checkNavDirsSize(iconSize: number): boolean {
    const iconNum = this.card?.layoutNavigationIcons?.length ?? 0;

    if (iconNum && this.navDirsWidth) {
      return (this.navDirsWidth - iconSize * iconNum) / (iconNum + 1) >= 6;
    }

    return true;
  }

  public setParamWithoutNavigationIcons(): void {
    this.paramType = ParamsType.NO_NAV_ICONS;
    this.cardMarginUpperHalf = {
      top: '12vp',
      left: '12vp',
      right: '12vp',
      bottom: '12vp'
    };
    this.currNavDirectionHeight = '80vp';
    this.currNavDirectionWidth = '80vp';
    this.mainNavInfoSizeRes = $r('sys.float.ohos_id_text_size_headline7');
    this.mainViceSpace = $r('sys.float.ohos_id_text_paragraph_margin_xs');
    this.navInfoMargin = {
      start: LengthMetrics.vp(12),
      end: LengthMetrics.vp(0)
    };
    this.navInfoAlignRule = {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: `nav-direction-icon_${this.live.hashCode}`, align: HorizontalAlign.End },
      right: { anchor: `nav-app-icon_${this.live.hashCode}`, align: HorizontalAlign.End },
    };
    this.appIconAlignRule = {
      top: { anchor: `__container__`, align: VerticalAlign.Top },
      right: { anchor: '__container__', align: HorizontalAlign.End },
    };
  }

  public setParamWithBottom(): void {
    this.paramType = ParamsType.BOTTOM;
    this.cardMarginUpperHalf = {
      top: '12vp',
      left: '12vp',
      right: '12vp',
      bottom: '4vp'
    };
    this.cardMarginBottomHalf = {
      top: '0vp',
      left: '12vp',
      right: '12vp',
      bottom: '12vp'
    };
    this.currNavDirectionHeight = '64vp';
    this.currNavDirectionWidth = '64vp';
    this.mainNavInfoSizeRes = $r('sys.float.ohos_id_text_size_headline8');
    this.mainViceSpace = $r('sys.float.ohos_id_text_paragraph_margin_xs');
    this.navInfoMargin = {
      start: LengthMetrics.vp(12),
      end: LengthMetrics.vp(24)
    };
    this.navInfoAlignRule = {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: `nav-direction-icon_${this.live.hashCode}`, align: HorizontalAlign.End },
      right: { anchor: `nav-app-icon_${this.live.hashCode}`, align: HorizontalAlign.Start },
    };
    this.appIconAlignRule = {
      top: { anchor: `__container__`, align: VerticalAlign.Top },
      right: { anchor: '__container__', align: HorizontalAlign.End },
    };
  }

  public setNavDirectIcons(hasNavDirectionIcons: boolean): void {
    this.hasNavDirectionIcons = hasNavDirectionIcons;
  }

  public getCardScale(): string {
    if (this.cardScale && this.cardScale < 1) {
      return '1.5px';
    }
    return '1px';
  }

  public getTimerText(text: string, timer?: LiveTimerModel): string {
    if (!timer?.uid) {
      return text
    }
    const timeText = this.vmInjector.getTimerVm().getTimerText(timer);
    const timeTemplateReg = /\$\{placeholder.timer\}/g;
    const result = text.replace(timeTemplateReg, timeText)
    return result;
  }

  /**
   * 固定区域高度
   */
  public getFixedAreaHeight(): number {
    let height = 0;
    if (this.hasNavDirectionIcons) {
      if (!this.card.layoutIsNavigationIconsDisplayed) {
        height = 120;
      } else {
        height = 72;
      }
    } else {
      height = 48;
    }
    return height + ResourceVm.instance.getLiveFontScaleHeightDiff(this.fontFixedAreaHeight);
  }

  public getCardHeight(): number {
    return (this.hasNavDirectionIcons ? LiveStyle.LIVE_OTHER_CARD_HEIGHT : LiveStyle.LIVE_SYSTEM_CARD_HEIGHT) +
      ResourceVm.instance.getLiveFontScaleHeightDiff(this.fontFixedAreaHeight);
  }

  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    return richText.textColor ?? LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }
}