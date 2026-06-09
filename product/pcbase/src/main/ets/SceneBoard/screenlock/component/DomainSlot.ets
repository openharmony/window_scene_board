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

import Constants from '../common/Constants';
import { CommonStyle } from '../style/CommonStyle';
import { UserStyle } from '../style/UserStyle';
import { LengthMetrics, LengthUnit } from '@kit.ArkUI';


@Component
export struct DomainSlot {
  private textMarginLeft: number = 0;
  private iconMarginLeft: number = 0;
  private marginBottom: number = 0;
  @StorageLink('systemLanguage') systemLanguage: string = Constants.SYSTEM_LANGUAGE_CHINESE;
  @State commonStyle: CommonStyle = CommonStyle.getInstance();
  @State userStyle: UserStyle = UserStyle.getInstance();
  @Prop isHover: boolean = false;

  private getBackgroundColor(): ResourceColor {
    if (this.isHover) {
      return this.userStyle.style.multiUserItemHoverEnterpriseLogoBgColor;
    }
    return this.commonStyle.style.ultraThinColor;
  }

  private getBackgroundBlur(): number {
    if (this.isHover) {
      return this.userStyle.style.multiUserItemHoverEnterpriseLogoBgBlur;
    }
    return this.commonStyle.style.ultraThinRadius;
  }

  private getBackgroundSaturation(): number {
    if (this.isHover) {
      return this.userStyle.style.multiUserItemHoverEnterpriseLogoBgSaturation;
    }
    return this.commonStyle.style.ultraThinSaturation;
  }

  private getBackgroundBrightness(): number {
    if (this.isHover) {
      return this.userStyle.style.multiUserItemHoverEnterpriseLogoBgBrightness;
    }
    return this.userStyle.style.enterpriseBackBrightness;
  }

  build() {
    if (this.systemLanguage.includes(Constants.SYSTEM_LANGUAGE_CHINESE)) {
      Stack({ alignContent: Alignment.Center }) {
        Text() {
          Span($r('app.string.domain_slot'))
            .font({
              family: 'HarmonyHeiTi',
              weight: FontWeight.Medium,
              size: this.userStyle.domainFontSize
            })
            .textBackgroundStyle({color: this.getBackgroundColor()})
            .saturate(this.getBackgroundSaturation())
            .backgroundColor(this.getBackgroundColor())
            .textShadow(this.userStyle.style.enterpriseTextShadow)
        }
          .fontColor(this.userStyle.style.enterpriseTextColor)
          .textAlign(TextAlign.Center)
      }
      .border({
        width: {
          left: $r('app.float.screen_lock_domain_slot_border_width'),
          right: $r('app.float.screen_lock_domain_slot_border_width'),
          top: $r('app.float.screen_lock_domain_slot_border_height'),
          bottom: $r('app.float.screen_lock_domain_slot_border_height')
        }
      })
      .borderRadius(4)
      .borderColor(this.getBackgroundColor())
      .saturate(this.getBackgroundSaturation())
      .backgroundColor(this.getBackgroundColor())
      .margin({
        left: this.textMarginLeft,
        bottom: this.marginBottom
      })
    } else {
      Stack() {
        Column()
          .width(24)
          .height(24)
          .borderRadius(12)
          .backgroundEffect({ radius: this.getBackgroundBlur() })
          .saturate(this.getBackgroundSaturation())
          .brightness(this.getBackgroundBrightness())
          .backgroundColor(this.getBackgroundColor())

        Image(this.userStyle.style.enterpriseIcon).draggable(false)
          .width(16)
          .height(16)
          .fillColor(this.userStyle.style.enterpriseIconColor)
      }
      .margin({
        left: this.iconMarginLeft,
        bottom: this.marginBottom
      })
    }
  }
}