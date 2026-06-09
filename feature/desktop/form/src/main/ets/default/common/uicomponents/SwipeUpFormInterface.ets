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
import Want from '@ohos.app.ability.Want';
import { CardItemInfo } from '@ohos/launchercommon';

export class BaseInfo {
  public id?: number;
  public name?: string;
}

export class FormAppInfo extends BaseInfo {
  public bundleName?: string;
  public appName?: string;
  public applicationLabelId?: number;
  public appLabelId?: number;
}


export class PageDesktopDragItemInfo extends FormAppInfo {
  public cardId?: string;
  public cardName?: string;
  public amoduleName?: string;
  public moduleName?: string;
  public cardDimension?: number;
  public formConfigAbility?: string;
  public area?: number[];
  public abilityName?: string;
  public dimension?: object | number;
}

// 对象类型接口
export class SwipeCardItemInfo {
  public id?: string;
  public name?: string;
  public cardId?: string;
  public bundleName?: string;
  public abilityName?: string;
  public moduleName?: string;
  public dimension?: number;
  public cardName?: string;
  public cardDimension?: number;
  public area?: number[];
  public description?: string;
  public formConfigAbility?: string;
  public appLabelId?: number;
  public appName?: string;
  public supportDimensions: number[] = [];
  public page?: number;
  public column?: number;
  public row?: number;
  public totleDimensionCount?: number;
  public isTransparent?: boolean;
}