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
import { GlassLayoutColor } from '../../common/constants/GlassLayoutConstants';
import { GlassShowToastOptions } from '../manager/GlassToastManager';
import { GlassToastStyle } from '../view/GlassToastStyle';
import { GlassToastVM, ToastContentCallBack } from '../vm/GlassToastVM';

const TAG = 'GlassToastContent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassToastContent {
  @State toastOpt: GlassShowToastOptions | null = null;

  aboutToAppear(): void {
    log.info(`aboutToAppear`);
    GlassToastVM.getInstance().init(this as ToastContentCallBack);
  }

  aboutToDisappear(): void {
    GlassToastVM.destroyInstance();
    log.info(`aboutToDisAppear`);
  }

  public getToast(): GlassShowToastOptions | null {
    return this.toastOpt;
  }

  public notifyToastChange(opt: GlassShowToastOptions | null): void {
    this.toastOpt = opt;
  }

  build() {
    if (this.toastOpt) {
      Column() {
        Row() {
          Text(this.toastOpt.message)
            .fontSize(GlassToastStyle.FONT_SIZE_36)
            .fontWeight(GlassToastStyle.TOAST_FONT_WEIGHT)
            .lineHeight(GlassToastStyle.TOAST_FONT_HEIGHT)
            .fontColor(this.toastOpt.textColor ? this.toastOpt.textColor :
            GlassLayoutColor.TEXT_TOAST_COLOR)
            .textAlign(TextAlign.Center)
        }
        .backgroundColor(this.toastOpt.backgroundColor ? this.toastOpt.backgroundColor :
        GlassLayoutColor.BACKGROUND_TOAST_COLOR)
        .backgroundBlurStyle(this.toastOpt.backgroundBlurStyle ? this.toastOpt.backgroundBlurStyle :
        BlurStyle.COMPONENT_ULTRA_THICK
        )
        .shadow(this.toastOpt.shadow ? this.toastOpt.shadow : ShadowStyle.OUTER_DEFAULT_MD)
        .borderRadius(GlassToastStyle.TOAST_BORDER_RADIUS)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .padding(GlassToastStyle.TOAST_PADDING)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }
}