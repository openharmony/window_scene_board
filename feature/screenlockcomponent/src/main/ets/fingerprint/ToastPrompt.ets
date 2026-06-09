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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { DynamicFontSize, sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';

const TAG = 'ToastPrompt';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const COMPONENT_ID_TOAST_PROMPT = TAG + "_Text_prompt";

@Component
export default struct ToastPrompt {
  @Prop @Watch('updatePrompt') prompt: string | undefined;
  @State fontScale: DynamicFontSize = sFontScaleUtil.realDynamicSize;
  aboutToAppear() {
    this.updatePrompt();
  }

  aboutToDisappear() {
  }

  /**
   * 在无障碍模式下输入密码界面指纹Tip改变主动播报事件
   *
   * @param bundleName 主动播报信息
   *
   */
  private updatePrompt(): void {
    log.showInfo(`updatePrompt`);
    if (AccessibilityUtil.isAccessibilityMode()) {
      AccessibilityUtil.sendAccessibility(this.prompt);
    }
  }

  build() {
    Column() {
      Text(this.prompt)
        .id(COMPONENT_ID_TOAST_PROMPT)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .minFontScale(sFontScaleUtil.minFontSize)
        .maxFontScale(sFontScaleUtil.maxToastFontSize)
        .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
        .fontWeight(FontWeight.Regular)
        .fontFamily($r('app.float.pwd_prompt_font_family'))
        .textAlign(TextAlign.Center)
    }
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .backgroundColor($r('sys.color.ohos_id_color_instant_tip_bg'))
    .justifyContent(FlexAlign.Center)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .transition(TransitionEffect.OPACITY.animation({ duration: 65, curve: Curve.Ease }))
  }
}