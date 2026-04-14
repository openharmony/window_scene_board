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

import { AttributeUpdater, LengthMetrics } from '@kit.ArkUI';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { CardItemInfo, CommonConstants } from '@ohos/launchercommon';
import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';
import { FormItemData } from '../data/FormItemVm';
import { SwiperFormAnimate } from '../event/swiperlayoutevent/SwiperAnimateViewModel';

export class ScreenLockParentUpdater extends AttributeUpdater<CommonAttribute> {
  private formItemUIConfig: FormItemData = new FormItemData();
  protected swiperFormAnimate: SwiperFormAnimate = new SwiperFormAnimate();

  constructor(formItemUIConfig: FormItemData, swiperFormAnimate: SwiperFormAnimate) {
    super();
    this.formItemUIConfig = formItemUIConfig;
    this.swiperFormAnimate = swiperFormAnimate;
  }

  initializeModifier(instance: CommonAttribute): void {
    instance.margin({
        start: LengthMetrics.vp(this.swiperFormAnimate.getStartOffset(this.formItemUIConfig.index))
      })
  }
}

export class ParentUpdater extends AttributeUpdater<CommonAttribute> {
  private formItemUIConfig: FormItemData = new FormItemData();
  private formItem: CardItemInfo = new CardItemInfo();
  private isCurrent: boolean = false;
  protected swiperFormAnimate: SwiperFormAnimate = new SwiperFormAnimate();

  constructor(formItemUIConfig: FormItemData, formItem: CardItemInfo,
    isCurrent: boolean, swiperFormAnimate: SwiperFormAnimate) {
    super();
    this.formItemUIConfig = formItemUIConfig;
    this.formItem = formItem;
    this.isCurrent = isCurrent;
    this.swiperFormAnimate = swiperFormAnimate;
  }

  initializeModifier(instance: CommonAttribute): void {
    instance.backgroundColor(this.formItem.isTransparent ?
      $r('app.color.transparent_form_background_color') : Color.Transparent)
      .shadow((this.formItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE ||
        !CheckEmptyUtils.isEmpty(this.formItem.shortcutInfo)) ? null : {
        radius: $r('app.float.normal_form_manager_radius'),
        color: $r('app.color.normal_form_manager_shadow_color'),
        offsetY: $r('app.float.normal_form_manager_offset')
      })
      .width(this.formItemUIConfig.formDisplayWidth)
      .height(this.formItemUIConfig.formDisplayHeight)
      .margin({
        start: LengthMetrics.vp(this.swiperFormAnimate.getStartOffset(this.formItemUIConfig.index))
      })
      .opacity(AppStorage.get('enterFormManager') && this.isCurrent
        ? FormStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE : 1)
  }
}

export class FormUpdater extends AttributeUpdater<CommonAttribute> {
  private formItemUIConfig: FormItemData = new FormItemData();
  private dragable: boolean = true;

  constructor(formItemUIConfig: FormItemData, dragable: boolean) {
    super();
    this.formItemUIConfig = formItemUIConfig;
    this.dragable = dragable;
  }

  initializeModifier(instance: CommonAttribute): void {
    instance.backgroundColor(Color.Transparent)
      .width(this.formItemUIConfig.formDisplayWidth)
      .height(this.formItemUIConfig.formDisplayHeight)
      .draggable(this.dragable)
  }
}