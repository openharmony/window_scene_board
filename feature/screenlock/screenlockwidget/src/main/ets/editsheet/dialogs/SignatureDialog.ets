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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PerformanceMonitorUtil } from '@ohos/screenlockcommon';
import { DynamicFontSize, sFontScaleUtil } from '../../common/utils/FontScaleUtil';
import { SymbolGlyphModifier } from '@kit.ArkUI';


const TAG = 'SignatureDialog';
const DEFAULT_DIALOG_FOCUS_KEY: string = 'SignatureDialog.TextInput';
const PAD_DIALOG_WIDTH = 400;
export const DEFAULT_SIGNATURE_FOCUS_KEY: string = 'lockScreenSignatureText';
const SIGN_TEXT_LEN_LIMIT_200: number = 200;
const emojiRegex = new RegExp(
  '([\\ud83d\\udc00-\\ud83d\\ude4f\\ud83d\\ude80-\\ud83d\\udeff])|' + // 表情符号
    '([\\ud83d[\\udc00-\\ude4f\\ude80-\\udeff])|' + // 表情符号扩展
    '([\\ud83c\\udde6-\\ud83c\\uddff\\ud83c\\uddfe\\ud83c\\uddff])|' + // 旗帜
    '([\\ud83e\\udd10-\\ud83e\\uddff])|' + // 额外的表情符号（2019-2021）
    '([\\ud83e\\ude00-\\ud83e\\ude4f])|' + // 额外的表情符号（2022-2023）
    '([\\u{1F600}-\\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2611}\u{262F}\u{2702}\u{2705}-\u{2706}\u{2708}-\u{2709}\u{270B}-\u{270C}\u{270E}-\u{270F}\u{2711}-\u{2718}\u{271A}-\u{2719}\u{271B}-\u{271F}\u{2721}-\u{2722}\u{2724}-\u{2725}\u{2727}-\u{2729}\u{272B}-\u{272F}\u{2731}-\u{2732}\u{2734}-\u{2755}\u{2757}-\u{2761}\u{2763}-\u{2764}\u{2766}-\u{27A0}\u{27A1}-\u{27AD}\u{27AF}-\u{27B0}\u{2B50}\u{2B55}\u{2934}\u{2935}\u{3030}\u{303D}\u{3297}\u{3299}])', // 其他表情符号和符号
  'u'
);
const allowCodeRegex = new RegExp('([\u{2702}\u{2703}\u{2707}\u{2710}\u{2719}\u{2720}\u{2723}\u{2725}\u{2726}\u{272A}\u{2756}\u{2762}\u{2765}\u{27A0}\u{27AD}\u{27AE}])', 'u');
const disableCodeRegex = new RegExp('([\u{2611}\u{262F}\u{270D}\u{2712}\u{2714}\u{2718}\u{2721}\u{2763}])', 'u');
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@CustomDialog
export default struct SignatureDialog {
  @Link isSelected: boolean;
  @Link textValue: string;
  @Link titleContent: Resource;
  @State inputValue: string = this.textValue.toString();
  @State fontScale: DynamicFontSize = sFontScaleUtil.realDynamicSize;
  private controller?: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  aboutToAppear(): void {
    PerformanceMonitorUtil.reportLockscreenEditSignInput();
    if (this.textValue.length === 0) {
      PerformanceMonitorUtil.reportLockscreenEditStatus(PerformanceMonitorUtil.SIGN);
    }
    log.showInfo(`signarture: ${this.textValue.length}, ${this.inputValue.length}`);
  }

  aboutToDisappear() {
    this.controller?.close();
    this.controller = undefined;
  }

  // 检测输入的内容是否允许输入，emoji不允许
  private inputInsertCheck = (insertValue: string): boolean => {
    let isAllow = allowCodeRegex.test(insertValue);
    let isDisable = disableCodeRegex.test(insertValue);
    let isEmoji = emojiRegex.test(insertValue);
    if (isAllow) {
      return true;
    }
    if (isDisable || isEmoji) {
      return false;
    }
    return true;
  }

  @Builder
  TextInputComponent() {
    TextInput({ text: this.inputValue })
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .cancelButton({ icon: new SymbolGlyphModifier($r('sys.symbol.xmark'))
        .fontSize($r('app.float.art_sign_text_input_xmark_size'))
        .fontColor([$r('sys.color.ohos_id_color_primary')]),
        style: CancelButtonStyle.CONSTANT })
      .fontSize(this.fontScale.searchComponentFontSize)
      .fontWeight(FontWeight.Regular)
      .draggable(false)
      .id(`${TAG}_textInput`)
      .layoutWeight(1)
      .borderRadius($r('app.float.dialog_corner'))
      .align(Alignment.Start)
      .margin({
        left: $r('app.float.signature_dialog_padding_horizontal'),
        right: $r('app.float.signature_dialog_padding_horizontal'),
        top: $r('app.float.signature_dialog_padding_vertical'),
        bottom: $r('app.float.signature_dialog_padding_vertical'),
      })
      .height($r('app.float.signature_dialog_input_height'))
      .maxLength(SIGN_TEXT_LEN_LIMIT_200)
      .onWillInsert((info: InsertValue) => {
        return this.inputInsertCheck(info.insertValue ?? '');
      })
      .onChange((value: string) => {
        log.showWarn(`cancelButton signarture onChange:  ${value?.length}`)
        this.inputValue = value;
      })
      .key(DEFAULT_DIALOG_FOCUS_KEY)
  }

  @Builder
  confirmButton() {
    Button($r('app.string.confirm'))
      .onClick(() => {
        this.textValue = this.inputValue;
        log.showWarn(`confirmButton signarture onChange: ${this.textValue?.length}}`);
        if (this.textValue.length > 0) {
          this.isSelected = true;
        } else {
          this.isSelected = false;
        }
        this.controller?.close();
        this.confirm();
      })
      .backgroundColor(Color.Transparent)
      .fontSize(this.fontScale.confirmButtonFontSize)
      .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
      .height($r('app.float.signature_dialog_button_height'))
      .layoutWeight(1) // 布局权重1
  }

  @Builder
  cancelButton() {
    Button($r('app.string.cancel'))
      .onClick(() => {
        this.controller?.close();
        this.cancel();
      })
      .backgroundColor(Color.Transparent)
      .fontSize(this.fontScale.cancelButtonFontSize)
      .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
      .height($r('app.float.signature_dialog_button_height'))
      .layoutWeight(1) // 布局权重1
  }

  build() {
    Stack() {
      Column() {
        Text(this.titleContent)
          .draggable(false)
          .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          .minFontScale(sFontScaleUtil.minFontSize)
          .maxFontScale(sFontScaleUtil.maxFontSize)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Bold)
          .height($r('app.float.signature_dialog_title_line_height'))
        this.TextInputComponent()

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
          this.cancelButton()
          Blank()
            .color($r('sys.color.ohos_id_color_list_separator'))
            .height($r('app.float.signature_dialog_deliver_line_height'))
            .width('1px')// 分隔线宽度1px
            .margin({
              left: $r('app.float.signature_dialog_deliver_line_margin'),
              right: $r('app.float.signature_dialog_deliver_line_margin'),
            })
          this.confirmButton()
        }
        .margin({
          left: $r('app.float.signature_dialog_button_margin'),
          right: $r('app.float.signature_dialog_button_margin'),
          bottom: $r('app.float.signature_dialog_button_margin'),
          top: $r('app.float.signature_dialog_button_margin_top'),
        })
      }
      .borderRadius($r('app.float.dialog_corner'))
      .backgroundColor($r('sys.color.ohos_id_color_mask_thin'))
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { policy: 1 }, { disableSystemAdaptation: true })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .size({
      width: '100%',
      height: $r('app.float.signature_dialog_height'),
    })
    .constraintSize({
      maxWidth: $r('app.float.signature_dialog_max_width'),
    })
    .padding({
      left: $r('app.float.signature_dialog_margin'),
      right: $r('app.float.signature_dialog_margin'),
    })
    .onAppear(() => {
      focusControl.requestFocus(DEFAULT_DIALOG_FOCUS_KEY);
      PerformanceMonitorUtil.reportSignInputAppear(PerformanceMonitorUtil.SIGN_INPUT);
    })
    .onDisAppear(() => {
      focusControl.requestFocus(DEFAULT_SIGNATURE_FOCUS_KEY);
    })
  }
}