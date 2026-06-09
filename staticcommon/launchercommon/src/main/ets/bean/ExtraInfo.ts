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

/**
 * ExtraInfo 字段与预置布局对应
 */
export class ExtraInfo {
  public appName?: string;

  public cardName?: string;

  public applicationName?: string;

  public isSystemApp?: boolean;

  public isUninstallAble?: boolean;

  public applicationLabelId?: number;

  public kindId?: number;

  public installTime?: string;

  public areaType?: number;

  public bundleType?: number;

  public checked?: boolean;

  public x?: number;

  public cardDimension?: number;

  public formConfigAbility?:string;

  public geometryId?:string;

  public supportDimensions?: number[];

  public totleDimensionCount?: number;

  public applicationIconId?: number;

  public enterEditing?: boolean;

  public backgroundGeometryId?: string;

  public totalBadgeGeometryId?: string;

  public addIconGeometryId?: string;

  public itemType?: string | number;

  public kindDesc?: string;

  public isInDock?: boolean;

  public dockRegion?: number;

  public isFormDimension1x4?: boolean;

  public isDefaultActivated?: boolean = false;
}