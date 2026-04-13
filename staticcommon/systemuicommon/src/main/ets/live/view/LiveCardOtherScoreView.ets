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
import { SystemUIColorVm } from '../../vm/SystemUIColorVm';
import { ILiveCardOtherVm } from '../interface/ILiveCardOtherVm';
import { LiveCardScoreModel } from '../model/LiveCardScoreModel';
import { LiveNotification } from '../model/LiveNotification';
import { image } from '@kit.ImageKit';
import { ResUtils } from '@ohos/windowscene';
import { ILiveCardOtherScoreVm } from '../interface/ILiveCardOtherScoreVm';

export interface LiveCardOtherScoreViewParam {
  live: LiveNotification;
  cardInfo: LiveCardScoreModel;
  cardVm: ILiveCardOtherVm;
  cardScoreVm: ILiveCardOtherScoreVm;
  colorVm: SystemUIColorVm;
}

interface TeamScoreInfo {
  teamIcon?: image.PixelMap;
  teamName?: string;
  teamScore?: string;
  isReverse?: boolean;
  cardVm: ILiveCardOtherVm;
}

@Builder
export function LiveCardOtherScoreView($$: LiveCardOtherScoreViewParam) {
  if ($$.live) {
    Column() {
      Divider()
        .width('100%')
        .height('1px')
        .color($$.cardVm.dividerFgColor)
        .foregroundBrightness($$.cardVm.dividerBrightness)
        .visibility($$.cardInfo.layoutIsDisplayHorizontalLine ? Visibility.Visible : Visibility.None)

      // 用来占位，使得下面的元素底部排列
      Row().layoutWeight(1)

      Row() {
        buildTeamInfo({
          teamIcon: $$.cardInfo.layoutHostIcon,
          teamName: $$.cardInfo.layoutHostName,
          teamScore: $$.cardInfo.layoutHostScore,
          isReverse: false,
          cardVm: $$.cardVm,
        })

        Column() {
          constructRichText($$)
          Text($$.cardVm?.getTimerContent($$.cardInfo.layoutCompetitionTime))
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Regular)
            .fontSize('10vp')
            .fontColor($$.cardVm.contentFontColor)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .renderGroup($$.cardVm.contentRenderGroup)
        }
        .width($$.cardScoreVm?.timerContentWidth)
        .justifyContent(FlexAlign.Center)

        buildTeamInfo({
          teamIcon: $$.cardInfo.layoutGuestIcon,
          teamName: $$.cardInfo.layoutGuestName,
          teamScore: $$.cardInfo.layoutGuestScore,
          isReverse: true,
          cardVm: $$.cardVm,
        })
      }
      .width('100%')
      .padding({left: 16, right: 16})
      .alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.End)
    .width('100%')
    .height(72)
    .opacity($$.cardVm.extendOpacity)
    .padding({
      left: 12,
      right: 12,
      bottom: 10
    })
  }
}

@Builder
function buildTeamInfo($$: TeamScoreInfo) {
  Flex({
    direction: $$.isReverse ? FlexDirection.RowReverse : FlexDirection.Row,
    justifyContent: FlexAlign.End,
    alignItems: ItemAlign.Center,
  }) {
    Column() {
      Image($$.teamIcon)
        .width(54)
        .height(34)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .margin({ bottom: 4 })
        .visibility($$.teamIcon ? Visibility.Visible : Visibility.Hidden)
      Text($$.teamName)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .fontSize(ResUtils.getNumber($r('sys.float.ohos_id_text_size_caption')) + 'vp')
        .fontColor($$.cardVm.contentFontColor)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .renderGroup($$.cardVm.contentRenderGroup)
    }
    .width($r('app.float.live_view_card_score_team_width'))
    .alignItems(HorizontalAlign.Center)

    Text($$.teamScore)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Bold)
      .fontSize($r('app.float.live_view_other_card_score_font_size'))
      .fontColor($$.cardVm.titleFontColor)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup($$.cardVm.contentRenderGroup)
      .constraintSize({ minWidth: '20%' })
      .margin({ left: 12, right: 12 })
      .textAlign($$.isReverse ? TextAlign.End : TextAlign.Start)
      .flexGrow(1)
      .contentTransition({ flipDirection: FlipDirection.DOWN, enableBlur: true })
  }
  .layoutWeight(1)
}

@Builder
function constructRichText($$: LiveCardOtherScoreViewParam) {
  if ($$.cardInfo?.layoutCompetitionDesc) {
    Text() {
      Repeat($$.cardInfo?.layoutCompetitionDesc).each((data) => {
        Span(data.item.text).fontColor($$.cardVm.getContentFontColor(data.item))
      })
    }
    .fontFamily('HarmonyHeiTi')
    .fontWeight(FontWeight.Regular)
    .fontSize('10vp')
    .fontColor('#99000000')
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .renderGroup($$.cardVm.contentRenderGroup)
    .margin({ bottom: 2 })
  }
}