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
  public lockConfig?: string;

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

  public enableLockConfig(): ThemeOptions {
    this.lockConfig = ThemeOptions.ENABLE;
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