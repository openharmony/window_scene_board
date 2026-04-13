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

/**
 * 可空类型
 */
export type NullableType<T> = T | undefined | null;

export type Qualifier = 'base' | 'land' | 'dark' | 'unfolded' | string;

export type QualifierContent<T> = Map<Qualifier, T>;

/**
 * 主题参数
 */
export class ThemeOptions {
  public static readonly ENABLE: string = `1`;
  public home?: string;
  public lock?: string;
  public aod?: string;
  public icons?: string;
  public skin?: string;
  public fonts?: string;
  public sub_screen?: string;
  public fa?: string;
  public contents_switch?: string;
  public notify?: string;
  public long_take?: string;

  public enableLongTake(): ThemeOptions {
    this.long_take = ThemeOptions.ENABLE;
    return this;
  }

  public enableHome(): ThemeOptions {
    this.home = ThemeOptions.ENABLE;
    return this;
  }

  public enableFont(): ThemeOptions {
    this.fonts = ThemeOptions.ENABLE;
    return this;
  }

  public enableLock(): ThemeOptions {
    this.lock = ThemeOptions.ENABLE;
    return this;
  }

  public enableAod(): ThemeOptions {
    this.aod = ThemeOptions.ENABLE;
    return this;
  }

  public enableIcons(): ThemeOptions {
    this.icons = ThemeOptions.ENABLE;
    return this;
  }

  public enableSkin(): ThemeOptions {
    this.skin = ThemeOptions.ENABLE;
    return this;
  }

  public enableSubScreen(): ThemeOptions {
    this.sub_screen = ThemeOptions.ENABLE;
    return this;
  }

  public enableFa(): ThemeOptions {
    this.fa = ThemeOptions.ENABLE;
    return this;
  }

  public enableNotify(): ThemeOptions {
    this.notify = ThemeOptions.ENABLE;
    return this;
  }

  public disableContentSwitch(): ThemeOptions {
    this.contents_switch = '0';
    return this;
  }

  public disableNotify(): ThemeOptions {
    this.notify = '0';
    return this;
  }

  public value(): string {
    return JSON.stringify(this);
  }
}

export class ThemeInfoNew {
  public readonly id: string;
  public readonly editorId: string;
  public readonly isMixedOnlineResource: boolean; // 是否混搭在线主题资源
  public readonly originThemePack: NullableType<ThemePackInfo>; // 原始主题包信息
  public customThemePack?: NullableType<ThemePackInfo>; // 修改的主题包增量信息
  public isDefault: boolean = false;

  constructor(id: string, editorId: string, originThemePack: NullableType<ThemePackInfo>,
              customThemePack: NullableType<ThemePackInfo>, isMixedOnlineResource?: boolean) {
    this.id = id;
    this.editorId = editorId;
    this.originThemePack = originThemePack;
    this.customThemePack = customThemePack;
    this.isMixedOnlineResource = isMixedOnlineResource ?? false;
  }
}

export class ThemePackInfo {
  /**
   * 主题包路径,如：/sys_prod/variant/region_comm/china/resource/theme/themes/default
   */
  public srcPath: string = '';
  /**
   * 【JSON字符串】主题包描述文件内容
   */
  public description: string = '';
  /**
   * 【JSON字符串】主题包（锁屏）描述配置文件，用于配置锁屏相关信息。
   */
  public lockManifest: string = '';
  /**
   * 【json字符串】  锁屏时钟、卡片等配置信息
   */
  public lockConfig?: QualifierContent<string>;
  /**
   * 【JSON字符串】主题包（home）描述配置文件，用于配置桌面锁屏相关信息。
   */
  public homeManifest: string = ``;
}