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
import { IconExtendParam } from './IconExtendParam';

/**
 * IconColumn
 */
export default class IconInfo {
  // 图标类型
  iconType: IconPicType = IconPicType.NONE;

  // 分层图标前后景
  adaptivePic:string[] = [];

  // 融合图标base64
  combinePic: string = '';

  // 融合图标pixelMap
  combinePicSrc: image.PixelMap = undefined;

  // 分层图标前后景
  adaptivePicSrc:image.PixelMap[] = [];

  // 标签
  label: string = '';

  // 应用版本号
  appVersion: string = '';

  // 包名
  bundleName: string = '';

  // 模块名
  moduleName: string = '';

  // ability名
  abilityName: string = '';

  // 通过hds处理时使用的包名
  hdsBundleName: string = '';

  // 查询图标的扩展参数信息
  param: IconExtendParam;

  constructor(iconType?:IconPicType, adaptivePic?: string[], combinePic?: string, combinePicSrc?: image.PixelMap, label?: string, appVersion?: string) {
    if (iconType) {
      this.iconType = iconType;
    }
    if (adaptivePic) {
      this.adaptivePic = adaptivePic;
    }
    if (combinePic) {
      this.combinePic = combinePic;
    }
    if (combinePicSrc) {
      this.combinePicSrc = combinePicSrc;
    }
    if (label) {
      this.label = label;
    }
    if (appVersion) {
      this.appVersion = appVersion;
    }
  }

}

/**
 * IconColumn
 */
export class IconDatabaseColumn {
  static readonly BUNDLE_NAME: string = 'bundle_name';
  static readonly MODULE_NAME: string = 'module_name';
  static readonly ABILITY_NAME: string = 'ability_name';
  static readonly LABEL_NAME: string = 'label_name';
  static readonly ICON_TYPE: string = 'icon_type';
  static readonly FORE_PIC: string = 'fore_pic';
  static readonly BACK_PIC: string = 'back_pic';
  static readonly COMBINE_PIC: string = 'combine_pic';
  static readonly SYSTEM_STATE: string = 'system_state';
  static readonly APP_VERSION: string = 'app_version';
}

/**
 * IconPicType
 */
export enum IconPicType {
   NORMAL = 'normal',
   ADAPTIVE = 'adaptive',
   NONE = 'none'
}