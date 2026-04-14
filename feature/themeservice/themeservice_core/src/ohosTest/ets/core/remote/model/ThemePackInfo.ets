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
import { QualifierContent } from '@ohos/themeservice_inner_api/Index';

export class ThemePackInfo {
  /**
   * 主题包路径,如：/sys_prod/variant/region_comm/china/resource/theme/themes/default
   */
  public srcPath: string = '';
  /**
   * 【JSON字符串】主题包描述文件内容
   */
  public description: ThemeDescription;
  /**
   * 【JSON字符串】主题包（锁屏）描述配置文件，用于配置锁屏相关信息。
   */
  public lockManifest: LockManifest;
  /**
   * 【json字符串】  锁屏时钟、卡片等配置信息
   */
  public lockConfig: Nullable<QualifierContent<LockConfig>>;
  /**
   * 【JSON字符串】主题包（home）描述配置文件，用于配置桌面锁屏相关信息。
   */
  public homeManifest: HomeManifest;

  constructor(description: ThemeDescription, lockManifest: LockManifest, homeManifest: HomeManifest) {
    this.description = description;
    this.lockManifest = lockManifest;
    this.homeManifest = homeManifest;
  }
}

export class ThemeDescription {
  public id: string;
  public origin: string;
  public title: string;

  constructor(id: string, origin: string, title: string) {
    this.id = id;
    this.origin = origin;
    this.title = title;
  }
}

export class LockManifest {
  public type: string;
  public image: Image;
  public clockVisible: boolean;

  constructor(type: string, image: Image, clockVisible: boolean) {
    this.type = type;
    this.image = image;
    this.clockVisible = clockVisible;
  }
}

export class LockConfig {
  public clockConfig?: LockscreenClockConfig;
  public formConfig?: LockscreenFormConfig[];
  public formPanelPositionY: number;

  constructor(formPanelPositionY: number) {
    this.formPanelPositionY = formPanelPositionY;
  }
}

export class LockscreenClockConfig {
  public positionX?: number;
  public positionY?: number;
  public textShadow?: boolean;
  public textBlurEffect?: boolean;
  public signatureText?: string;
  public editStatus?: boolean;
  public dateVisible?: boolean;
  public lunarVisible?: boolean;
  public signatureVisible?: boolean;
  public textColor?: string;
  public fontFamily?: string;
}

export class LockscreenFormConfig {
  public positionX: number;
  public positionY: number;
  // 宽度占用行数
  public dimensionX: number = 1;
  public formInfo: object;

  constructor(positionX: number, positionY: number, dimensionX: number, formInfo: object) {
    this.positionX = positionX;
    this.positionY = positionY;
    this.dimensionX = dimensionX;
    this.formInfo = formInfo;
  }
}

export class HomeManifest {
  public type: string;
  public image: Image;
  public wallpaperTouchable: boolean;

  constructor(type: string, image: Image, wallpaperTouchable: boolean) {
    this.type = type;
    this.image = image;
    this.wallpaperTouchable = wallpaperTouchable;
  }
}

export class Image {
  public src: string = ``;
}