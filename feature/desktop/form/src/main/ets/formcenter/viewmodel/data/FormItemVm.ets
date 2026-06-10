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

import { image } from '@kit.ImageKit';
import { CardItemInfo } from '@ohos/launchercommon';
import { FormUIConfig } from '../../interfaces/FormItemBuilderInterface';
import Want from '@ohos.app.ability.Want';
import { AttributeUpdater } from '@kit.ArkUI';
import { NavDestinationLayout } from '../../viewstyles/manager/NavConfig';

export interface FormItemAnimaInterface {
  animateScale: number;
  dragSnapshot?: image.PixelMap,
}

export class FormItemAnimData {
  @Track public animateScale: number = 1;
  @Track public dragSnapshot?: image.PixelMap = undefined;
  @Track public offset?: number = 0;
  @Track public isLongPressHide?: boolean;
}

export class FormItemData implements FormUIConfig {
  public formItem: CardItemInfo = new CardItemInfo();
  public want?: Want | undefined;
  public formDisplayWidth?: number | undefined;
  public formDisplayHeight?: number | undefined;
  public formWidth?: number | undefined;
  public formHeight?: number | undefined;
  public formRadius: number = 0;
  public formScale: number = 1;
  // 卡片拖拽镜像的缩放倍率
  public dragScale: number = 1;
  public cardId: string = '';
  public index: number = 0;
  public layoutType: number = NavDestinationLayout.SWIPER;
  public parentUpdater?: AttributeUpdater<CommonAttribute> = new AttributeUpdater();
  public formUpdater?: AttributeUpdater<CommonAttribute> = new AttributeUpdater();
  // 是否支持提亮操作
  public isSupportBrightness?: boolean;
  @Track public formOpacity: number = 1;
  @Track public hiddenStrokes?: boolean = false;

  //内描边
  public isNeedFormInnerLine?: boolean = true;
  // 渐显动效
  public hasFadeInAnimation?: boolean = false;
}