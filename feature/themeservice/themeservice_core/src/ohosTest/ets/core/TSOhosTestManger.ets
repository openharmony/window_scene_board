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
import { MockKit } from '@ohos/hypium';
import { Singleton, TsContext } from '@ohos/themeservicebase/Index';
import { TSManager, TSRemoteApi } from '@ohos/themeservicekit/Index';
import { TSInitializer } from '../../../main/ets/service/TSInitializer';
import { BundleMocker } from '../mock/BundleMocker';
import {
  TSCoreRemoteApi,
  TSCoreRemoteCallerImpl,
  TSLemRemoteApi,
  TSSubScreenRemoteApi
} from './remote/TSCoreRemoteCaller';

export class TSOhosTestManger {
  private static sInstance: Singleton<TSOhosTestManger> =
    new Singleton<TSOhosTestManger>(() => new TSOhosTestManger);
  private _context?: TsContext;

  public static getContext(): TsContext {
    return TSOhosTestManger.sInstance.get()._context!;
  }

  public static subscribeTsApplication(context: TsContext): void {
    TSOhosTestManger.sInstance.get()._context = context;
    TSInitializer.init(context);
  }

  public static getTsCoreRemoteApi(): TSCoreRemoteApi {
    return new TSCoreRemoteCallerImpl(TSOhosTestManger.getContext()!) as TSCoreRemoteApi;
  }

  public static getTsLemRemoteApi(): TSLemRemoteApi {
    return new TSCoreRemoteCallerImpl(TSOhosTestManger.getContext()!) as TSLemRemoteApi;
  }

  public static getTsKitRemoteApi(): TSRemoteApi {
    return TSManager.getRemoteApi(TSOhosTestManger.getContext());
  }

  /**
   * 主题app调用远程接口
   * @param callable 调用api callable
   * @returns 结果
   */
  public static async hwAppCallApi<T>(callable: (api: TSCoreRemoteApi) => Promise<T>): Promise<T> {
    let mocker: MockKit = BundleMocker.mockHwApp();
    let result: Promise<T> = callable(TSOhosTestManger.getTsCoreRemoteApi());
    result.finally(() => BundleMocker.clear(mocker));
    return result;
  }

  /**
   * 演示app调用远程接口
   * @param callable 调用api callable
   * @returns 结果
   */
  public static async retailAppCallApi<T>(callable: (api: TSCoreRemoteApi) => Promise<T>): Promise<T> {
    let mocker: MockKit = BundleMocker.mockRetailApp();
    let result: Promise<T> = callable(TSOhosTestManger.getTsCoreRemoteApi());
    result.finally(() => BundleMocker.clear(mocker));
    return result;
  }

  /**
   * 合一编辑器调用远端接口
   * @param callable 调用api callable
   * @returns 结果
   */
  public static async themeEditorCallApi<T>(callable: (api: TSCoreRemoteApi) => Promise<T>): Promise<T> {
    return callable(TSOhosTestManger.getTsCoreRemoteApi());
  }

  public static getTsSubScreenRemoteApi(): TSSubScreenRemoteApi {
    return new TSCoreRemoteCallerImpl(TSOhosTestManger.getContext()!) as TSSubScreenRemoteApi;
  }

  /**
   * LEM调用远端接口
   * @param callable 调用api callable
   * @returns 结果
   */
  public static async lemCallApi<T>(callable: (api: TSLemRemoteApi) => Promise<T>): Promise<T> {
    return callable(TSOhosTestManger.getTsLemRemoteApi());
  }

  /**
   * 大桌面调用远端接口
   * @param callable 调用api callable
   * @returns 结果
   */
  public static async scbCallApi<T>(callable: (api: TSRemoteApi) => Promise<T>): Promise<T> {
    return callable(TSOhosTestManger.getTsKitRemoteApi());
  }

  public static stopRemoteService(): Promise<void> {
    return TSOhosTestManger.getContext().stopServiceExtensionAbility({
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'TSOhosTestServiceAbility',
    });
  }
}