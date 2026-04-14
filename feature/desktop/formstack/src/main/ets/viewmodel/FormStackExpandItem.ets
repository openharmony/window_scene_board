/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import {
  CardNodeController
} from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import { FormStackConstants } from '../common/FormStackConstants';

@Observed
export class FormStackExpandItem {
  public idStr: string = '';

  public cardNode: CardNodeController | null = null;

  public enableBlurBackground: boolean = false; // 是否支持模糊背板

  public translateX: number = 0;

  public translateY: number = 0;

  public slideAvoidY: number = 0; // 滑动避让偏移量

  public longPressAvoidY: number = 0; // 长按避让偏移量

  public rotateX: number = 0;

  public isVisible: boolean = true;

  public opacity: number = 1;

  public scaleX: number = 1;

  public _scaleX: number = 1; // 记录初始scale

  public scaleY: number = 1;

  public zIndex: number = 0;

  public shadowRadius: number = 0;

  public maskNeedRender: boolean = false;

  public maskOpacity: number = 0;

  public delImgVisible = false;

  public delImgShowHeight: number = 0;

  public trashHeadAngle: number = 0;

  public trashBodyAngle: number = 0;

  public bgBrightness: number = 1;

  public isDraggable: boolean = true;

  public getId(): string {
    return `${FormStackConstants.FORM_STACK_EXPAND_ID_PREFIX}_${this.idStr}`;
  }

  public toString(): string {
    return `id: ${this.idStr}, translateY: ${this.translateY}, rotateX: ${this.rotateX}.`;
  }
}