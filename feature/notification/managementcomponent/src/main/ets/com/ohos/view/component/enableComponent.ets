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

import { DeviceHelper } from '../../common/DeviceHelper';
import { LogDomain, Logger } from '../../common/BasicCommon';
import ConfigData from '../../common/constants'
import { ToastType, ToastUtil } from '../../common/ToastUtil';
import { ResourceUtil } from '../../common/ResourceUtil';

const TAG = 'ManagementComponent-EnableComponent';
const log: Logger = Logger.getLogHelper(LogDomain.NC);
const COMPONENT_ID_IMAGE = TAG + '_Image_icon';
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_STATE = TAG + '_Checkbox_state';

@Component
export default struct EnableComponent {
  @Prop initState: boolean = false;
  /**
   * 是否禁用点击事件
   */
  @Prop isChangeEventFbd: boolean = false;
  @State title: string = '';
  @State isBannerNtfAllowed: boolean | undefined = undefined;
  private initializationAction?: (params?: boolean) => Promise<boolean>;
  private settingAction: (params?: boolean) => void = ()=>{};
  private clickAction: (params?: boolean) => void = ()=>{};
  @Prop image: Resource | null = null;
  private bannerType: boolean = false;
  private toastMessage: Resource | undefined = undefined;
  private customAccessibilityText: string = '';

  build() {
    if (!DeviceHelper.isPC()) {
      this.buildPhoneOrPad();
    } else {
      Column() {
        Image(this.image).draggable(false)
          .id(COMPONENT_ID_IMAGE)
          .width(144)
          .height(96)
          .objectFit(ImageFit.Fill)

        Text(this.title).draggable(false)
          .id(COMPONENT_ID_TITLE)
          .margin({ top: 16 })
          .fontSize(16)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .opacity(0.9)
          .fontWeight(FontWeight.Medium)
          .width(ConfigData.WH_100_100)
          .textAlign(TextAlign.Center)

        Radio({ value: this.title, group: 'bannerNtfGroup' })
          .checked(this.isBannerNtfAllowed === undefined || this.isBannerShow() ? this.isBannerNtfAllowed :
            !this.isBannerNtfAllowed)
          .id(COMPONENT_ID_STATE)
          .width($r('app.float.enable_radio_width'))
          .height($r('app.float.enable_radio_width'))
          .radioStyle({
            checkedBackgroundColor: $r('sys.color.comp_background_emphasize')
          })
          .margin({ top: 16 })
          .onClick(() => {
            this.isBannerNtfAllowed = this.isBannerShow()
            this.clickAction();
          })
      }.width('100%')
      .onClick(() => {
        /* 整个控件点击也生效 */
        this.isBannerNtfAllowed = this.isBannerShow()
        this.clickAction();
      })
    }
  }

  @Builder
  buildPhoneOrPad() {
    Column() {
      this.buildEnableImage()

      if (this.title !== '') {
        Text(this.title).draggable(false)
          .id(COMPONENT_ID_TITLE)
          .margin({ top: $r('app.float.enableComp_margin_inside') })
          .fontSize($r('app.float.enableComp_font_size'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .opacity(0.9)
          .fontWeight(FontWeight.Medium)
          .width(ConfigData.WH_100_100)
          .textAlign(TextAlign.Center)
      }

      Checkbox()
        .id(COMPONENT_ID_STATE)
        .select(this.initState)
        .selectedColor(this.initState ? $r('app.color.batch_modif_id_color_emphasize') : $r('sys.color.ohos_id_color_switch_bg_off'))
        .borderColor($r('sys.color.ohos_id_color_switch_outline_off'))
        .margin({ top: $r('app.float.enableComp_margin_inside') })
        .onChange((value: boolean) => {
          if (this.isChangeEventFbd) {
            return;
          }
          log.showInfo(TAG, 'value change:' + value);
          this.initState = value;
          this.settingAction(value);
        })
        .onClick(() => {
          if (this.isChangeEventFbd) {
            return;
          }
          log.showDebug(TAG, `onClick = ${this.initState}`)
          this.clickAction(this.initState);
        })
        .hoverEffect(HoverEffect.None)
        .enabled(this.isChangeEventFbd ? false : true)
    }
    .width('100%')
    .onClick(() => {
      if (this.isChangeEventFbd) {
        if (this.toastMessage !== undefined) {
          ToastUtil.showToast({
            message: this.toastMessage
          }, ToastType.SCREEN_LOCK_NTF_STYLE_FORBIDDEN);
        }
        return;
      }
      /* 整个控件点击也生效 */
      this.initState = !this.initState;
      this.clickAction(this.initState);
    })
    .accessibilityGroup(true)
    .accessibilityText([
      this.customAccessibilityText,
      this.title,
      ResourceUtil.getStringSync(this.initState ? $r('app.string.check_box_selected') :
      $r('app.string.check_box_unchecked'))
    ].join(' '))
  }

  @Builder
  buildEnableImage() {
    if (this.isChangeEventFbd) {
      Column() {
        Image(this.image).draggable(false)
          .id(COMPONENT_ID_IMAGE)
          .width(this.getLockNotificationStyleImageWidth())
          .objectFit(ImageFit.Fill)
          .aspectRatio(DeviceHelper.isPhone() ? ConfigData.ENABLE_COMP_IMAGE_RATIO :
          ConfigData.ENABLE_COMP_IMAGE_RATIO_PAD)
      }
      .backgroundColor(Color.White)
      .opacity(0.4)
      .borderRadius($r('app.float.enable_component_image_radius'))
    } else {
      Image(this.image).draggable(false)
        .id(COMPONENT_ID_IMAGE)
        .width(this.getLockNotificationStyleImageWidth())
        .objectFit(ImageFit.Fill)
        .aspectRatio(DeviceHelper.isPhone() ? ConfigData.ENABLE_COMP_IMAGE_RATIO :
        ConfigData.ENABLE_COMP_IMAGE_RATIO_PAD)
    }
  }

  private getLockNotificationStyleImageWidth(): Length {
    return DeviceHelper.isPhone() ? $r('app.float.lock_notification_style_img_phone_width') :
    $r('app.float.lock_notification_style_img_pad_width');
  }

  private isBannerShow(): boolean {
    return this.bannerType == true;
  }

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear`);
    if (this.initializationAction) {
      this.initializationAction().then((data: boolean) => {
        log.showInfo(TAG, `initializationAction:${data}`);
        this.initState = data;
        this.isBannerNtfAllowed = data;
      });
    }
    log.showInfo(TAG, `customAccessibilityText ${this.customAccessibilityText}`);
  }
}