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
import { ColorMetrics, LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Constants from '../common/Constants';
import ctrlAltDelPanelModel from '../model/CtrlAltDelPanelModel';

const TAG = 'CancelView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
struct CancelView {
  @State fillBackgroundColor: Resource | Color = Color.Transparent;
  @StorageLink('FocusMoveIndex') focusMoveIndex: number = 0;

  build() {
    Stack() {
      Stack() {
        Text() {
          Span(ctrlAltDelPanelModel.functionList[ctrlAltDelPanelModel.functionList.length - 1].name)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.font_primary'))
            .width(Constants.CANCLE_VIEW_WIDTH)
            .fontSize($r('app.float.ctrl_alt_del_description_font_size'))
            .fontWeight(FontWeight.Medium)
            .align(Alignment.Center)
        }.textAlign(TextAlign.Center)
      }
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .width(Constants.CANCLE_VIEW_WIDTH)
      .height(Constants.CANCLE_VIEW_HEIGHT)
      .borderRadius(Constants.CANCLE_VIEW_RADIUS)
    }
    .id(ctrlAltDelPanelModel.functionList[ctrlAltDelPanelModel.functionList.length - 1].id)
    .focusable(this.focusMoveIndex === (ctrlAltDelPanelModel.functionList.length - 1))
    .width(Constants.CANCLE_VIEW_WIDTH)
    .height(Constants.CANCLE_VIEW_HEIGHT)
    .borderRadius(Constants.CANCLE_VIEW_RADIUS)
    .backgroundColor(this.fillBackgroundColor)
    .alignContent(Alignment.Center)
    .focusBox({
      strokeColor: ColorMetrics.resourceColor('#FFFFFF'),
      strokeWidth: LengthMetrics.vp(2)
    })
    .borderWidth(Constants.FUNCTION_ITEM_FOCUS_BORDER_WIDTH)
    .borderColor(this.focusMoveIndex === (ctrlAltDelPanelModel.functionList.length - 1) ? Color.White :
    Color.Transparent)
    .onHover((isHover: boolean) => {
      log.showInfo(`isHover: ${isHover}`);
      if (isHover) {
        this.fillBackgroundColor = $r('sys.color.interactive_hover');
      } else {
        this.fillBackgroundColor = Color.Transparent;
      }
    })
    .onClick((event: ClickEvent) => {
      ctrlAltDelPanelModel.functionList[ctrlAltDelPanelModel.functionList.length - 1].action();
    })
  }
}

export { CancelView };