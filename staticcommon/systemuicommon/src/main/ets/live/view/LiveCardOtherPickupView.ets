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
import { ResourceVm } from '../../vm/ResourceVm';
import { ILiveCardOtherPickupVm } from '../interface/ILiveCardOtherPickupVm';
import { ILiveCardOtherVm } from '../interface/ILiveCardOtherVm';
import { LiveCardPickupModel } from '../model/LiveCardPickupModel';
import { LiveNotification } from '../model/LiveNotification'

const CONTENT_ID = 'pick_up_content_id';

export interface LiveCardOtherPickupViewParam {
  live: LiveNotification;
  cardInfo: LiveCardPickupModel;
  cardVm: ILiveCardOtherVm;
  cardPickupVm: ILiveCardOtherPickupVm;
}

@Builder
export function LiveCardOtherPickupView($$: LiveCardOtherPickupViewParam) {
  if ($$.live) {
    Column() {
      Row({ space: 10 }) {
        buildExtendColumn($$)
        Image($$.cardInfo.layoutDescPic)
          .height('100%')
          .objectFit(ImageFit.Contain)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .constraintSize({ maxWidth: 100 })
          .visibility($$.cardInfo.layoutDescPic ? Visibility.Visible : Visibility.Hidden)
          .syncLoad(true)
      }
      .width('100%')
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)

      if ($$.cardInfo.layoutProviderName) {
        buildProviderName($$)
      }
    }
    .width('100%')
    .height(72)
    .opacity($$.cardVm.extendOpacity)
    .padding({
      left: 12,
      right: 12
    })
    .alignItems(HorizontalAlign.End)
  }
}

@Builder
function buildExtendColumn($$: LiveCardOtherPickupViewParam) {
  Column() {
    Text($$.cardInfo.layoutTitle)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Regular)
      .fontSize(ResourceVm.instance.getNumberVp($r('sys.float.ohos_id_text_size_body3')))
      .fontColor($$.cardVm.contentFontColor)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup($$.cardVm.contentRenderGroup)
      .margin({ bottom: 4 })
    buildStack($$);
  }
  .layoutWeight(1)
  .height('100%')
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Start)
}

@Builder
function buildProviderName($$: LiveCardOtherPickupViewParam) {
  Text($$.cardInfo.layoutProviderName)
    .fontFamily('HarmonyHeiTi')
    .fontWeight(FontWeight.Regular)
    .fontSize('8vp')
    .fontColor($$.cardVm.providerNameColor)
    .textAlign(TextAlign.Start)
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .renderGroup($$.cardVm.contentRenderGroup)
    .height(12)
}

@Builder
function buildStack($$: LiveCardOtherPickupViewParam) {
  RelativeContainer() {
    if ($$.cardInfo?.layoutUnderlineColor && $$.cardVm?.isShowUnderline) {
      Line()
        .height('7vp')
        .backgroundColor($$.cardInfo?.layoutUnderlineColor)
        .borderRadius('3.5vp')
        .opacity($$.cardVm?.underlineOpacity)
        .margin({ bottom: $$.cardPickupVm?.lineMarginBottom })
        .alignRules({
          start: { anchor: CONTENT_ID, align: HorizontalAlign.Start },
          end: { anchor: CONTENT_ID, align: HorizontalAlign.End },
          bottom: { anchor: CONTENT_ID, align: VerticalAlign.Bottom },
        })
    }
    Text($$.cardVm?.getTimerContent($$.cardInfo.layoutContent))
      .id(CONTENT_ID)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Bold)
      .fontSize($$.cardPickupVm?.contentFontSize)
      .fontColor($$.cardVm?.titleFontColor)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .maxLines(1)
      .wordBreak(WordBreak.BREAK_ALL)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        setTimeout(() => {
          $$.cardVm.contentLayoutLength = newValue?.width as number;
        }, 0)
      })
      .renderGroup($$.cardVm?.contentRenderGroup)
      .accessibilityText($$.cardVm.getAccessibilityText($$.cardInfo.layoutContent))
  }
}