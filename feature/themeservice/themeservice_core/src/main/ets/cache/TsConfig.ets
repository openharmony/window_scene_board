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
import { TServiceApi } from '@ohos/themeservice_inner_api/Index';
import { ContextUtil, PreferenceApi, Singleton } from '@ohos/themeservicebase/Index';

/**
 * theme service config
 */
export class TsConfig {
  public static readonly TS_DATA_VER: number = 1;
  private static readonly KEY_LAST_VERSION: string = `last_version`;
  private static readonly KEY_OS_VERSION: string = 'last_os_version';
  private static readonly INSTANCE: Singleton<TsConfig> = new Singleton<TsConfig>(() => new TsConfig());
  private readonly preferenceApi: PreferenceApi;

  private constructor() {
    this.preferenceApi = TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'ts_config');
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static get(): TsConfig {
    return TsConfig.INSTANCE.get();
  }

  /**
   * 获取升前的版本号
   * @returns 版本号
   */
  public getLastVersion(): Promise<number> {
    return this.preferenceApi.getNumber(TsConfig.KEY_LAST_VERSION, -1);
  }

  /**
   * 设置升级前的版本号
   * @param version 版本号
   * @returns 结果
   */
  public setLastVersion(version: number): Promise<void> {
    return this.preferenceApi.putNumber(TsConfig.KEY_LAST_VERSION, version);
  }

  /**
   * 获取升前的系统版本号
   * @returns 版本号
   */
  public getLastOSVersion(): Promise<string> {
    return this.preferenceApi.getString(TsConfig.KEY_OS_VERSION, '');
  }

  /**
   * 设置升级前的系统版本号
   * @param version 版本号
   * @returns 结果
   */
  public setLastOSVersion(version: string): Promise<void> {
    return this.preferenceApi.putString(TsConfig.KEY_OS_VERSION, version);
  }
}
