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
import { LiveScoreTemplate } from '../../../data/template/LiveScoreTemplate';
import { RichText as CustRichText } from '../../../data/template/LiveBaseTemplate';
import { DarkModeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { CardUtils } from '../LiveViewCardData';
import image from '@ohos.multimedia.image';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { AodStyleType, ImmersiveAodStyle } from '../../../../immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { ResUtils } from '@ohos/windowscene';
import { LiveTimerData } from '../../../data/extend/LiveTimerData';
import { NotificationType } from '../../../../constants/NotificationType';
import { ColorModeViewData } from '../../../../template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '../../../../template/newStyle/ColorModeViewModel';
import { ColorModeLiveViewData } from '../../../../template/newStyle/ColorModeLiveViewData';
import { CommonUtils } from '@ohos/basicutils';

interface TeamInfo {
  teamIcon?: image.PixelMap;
  teamName?: string;
  teamScore?: string;
  isReverse?: boolean;
}

/**
 * 扩展区为赛事比分模板：比如NBA比赛
 */
@Component
export struct ScoreComponent {
  @ObjectLink data: LiveScoreTemplate;
  @ObjectLink timerData: LiveTimerData;
  @State darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State colorModeLiveViewData: ColorModeLiveViewData = ColorModeViewModel.getInstance().getLiveViewData();
  @Prop dividerBrightnessOption?: BrightnessOptions;
  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);
  @Prop isSmallFoldOuterScreen: boolean = false;

  build() {
    if (this.data) {
      Column() {
        Divider()
          .width('100%')
          .height('1px')
          .color(this.aodStyle?.isAod ? $r('sys.color.ohos_id_color_list_separator') :
          this.colorModeViewData.calcSecondarySolidColor($r('app.color.live_card_divider_bg_color'),
            this.dividerBrightnessOption, this.colorModeLiveViewData.liveBgPickColor))
          .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined : this.dividerBrightnessOption)
          .visibility(this.getDividerVisibility())

        if (!this.isSmallFoldOuterScreen) {
          // 用来占位，使得下面的元素底部排列
          Row().layoutWeight(1)
        }

        Row() {
          this.buildTeamInfo({
            teamIcon: this.data.hostIcon,
            teamName: this.data.hostName,
            teamScore: this.data.hostScore
          })
          Column() {
            this.constructRichText()
            Text(this.getExtendContent())
              .accessibilityText(this.data.transformTimerAccessibilityText(
                this.data.competitionTime ?? '', this.timerData))
              .fontFamily('HarmonyHeiTi')
              .fontWeight(FontWeight.Regular)
              .fontSize('10vp')
              .fontColor(this.aodStyle?.isAod
                ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR)
                : $r('sys.color.ohos_id_color_text_secondary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .renderGroup(this.aodStyle?.isOneMirror ? false : true)
          }
            .width(34)
            .justifyContent(FlexAlign.Center)
          this.buildTeamInfo({
            teamIcon: this.data.guestIcon,
            teamName: this.data.guestName,
            teamScore: this.data.guestScore,
            isReverse: true
          })
        }
          .width('100%')
          .height(this.isSmallFoldOuterScreen ? 40 : undefined)
          .padding({left: 16, right: 16})
          .alignItems(VerticalAlign.Center)
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height(this.isSmallFoldOuterScreen ? 46 : 72)
      .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_EXTEND_COMPONENT_ALPHA) : undefined)
      .padding(this.isSmallFoldOuterScreen ? undefined : {
        left: 12,
        right: 12,
        bottom: 10
      })
    }
  }

  @Builder
  constructRichText() {
    if (this.data?.competitionDesc) {
      Text() {
        ForEach(this.data?.competitionDesc, (entry: CustRichText, index: number) => {
          Span(entry?.text).fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
            (this.darkModeState?.isDarkMode ? CardUtils.DARK_RICH_CONTEXT_COLOR : entry?.getCurrentTextColor()))
        })
      }
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Regular)
      .fontSize('10vp')
      .fontColor('#99000000')
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup(this.aodStyle?.isOneMirror ? false : true)
      .margin({ bottom: 2 })
    }
  }

  @Builder
  buildTeamInfo($$: TeamInfo) {
    Flex({
      direction: $$.isReverse ? FlexDirection.RowReverse : FlexDirection.Row,
      justifyContent: this.isSmallFoldOuterScreen ? FlexAlign.Start : FlexAlign.End,
      alignItems: ItemAlign.Center,
    }) {
      Column() {
        Image($$.teamIcon)
          .width(this.isSmallFoldOuterScreen ? 40 : 54)
          .height(this.isSmallFoldOuterScreen ? 24 : 34)
          .objectFit(ImageFit.Contain)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .margin({ bottom: 4 })
          .visibility($$.teamIcon ? Visibility.Visible : Visibility.Hidden)
        Text($$.teamName)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize(ResUtils.getNumber($r('sys.float.ohos_id_text_size_caption')) + 'vp')
          .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
            $r('sys.color.ohos_id_color_text_secondary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .renderGroup(this.aodStyle?.isOneMirror ? false : true)
      }
      .width(this.isSmallFoldOuterScreen ? 40 : $r('app.float.live_view_card_score_team_width'))
      .height(this.isSmallFoldOuterScreen ? '100%' : undefined)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(this.isSmallFoldOuterScreen ? FlexAlign.SpaceBetween : undefined)

      Text($$.teamScore)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(this.isSmallFoldOuterScreen ? FontWeight.Regular : FontWeight.Bold)
        .fontSize(this.isSmallFoldOuterScreen ? $r('app.float.live_view_other_card_small_fold_outer_screen_score_font_size') : $r('app.float.live_view_other_card_score_font_size'))
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
          $r('sys.color.ohos_id_color_text_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .renderGroup(this.aodStyle?.isOneMirror ? false : true)
        .constraintSize({ minWidth: '20%' })
        .margin(this.isSmallFoldOuterScreen ? { left: 8, right: 8 } : { left: 12, right: 12 })
        .textAlign(TextAlign.Center)
        .flexGrow(1)
    }
      .layoutWeight(1)
      .height(this.isSmallFoldOuterScreen ? '100%' : undefined)
  }

  private getDividerVisibility(): Visibility {
    if (this.isSmallFoldOuterScreen) {
      return Visibility.Hidden;
    }
    return this.data?.isDisplayHorizontalLine ? Visibility.Visible : Visibility.None;
  }

  /**
   * 特殊处理：扩展区content长度小于1，则不显示文本
   *
   * @returns 拓展区文本
   */
  getExtendContent(): string {
    if (CommonUtils.isInvalid(this.data)) {
      return '';
    }
    let result = this.data.transformTimerText(this.data.competitionTime ?? '', this.timerData)
    if (result.trim().length === 0) {
      return '';
    }
    // 含计时器控件的实况拓展区，AOD下显示为正在计时或正在倒计时
    if (this.aodStyle?.isAod && this.data.isTimeTemplate) {
      if (this.timerData?.isCountDown) {
        return ResUtils.getInnerString($r('app.string.aod_count_down_timer_text'));
      }
      return ResUtils.getInnerString($r('app.string.aod_timing_timer_text'));
    }
    return result;
  }
}