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
export { StoreCache, VERSION_EMPTY } from './src/main/ets/cache/StoreCache';

export type { StoreManager, StoreMigrator } from './src/main/ets/cache/StoreCache';

export { MemoryCache } from './src/main/ets/cache/MemoryCache';

export { createPreference } from './src/main/ets/cache/PreferenceApi';

export type { PreferenceApi } from './src/main/ets/cache/PreferenceApi';

export { PreferenceStoreCache } from './src/main/ets/cache/PreferenceStoreCache';

export type { CalleeMethodSet, CallerInfo } from './src/main/ets/remote/RemoteCallee';

export { createRemoteStub } from './src/main/ets/remote/RemoteCallee';

export type { RemoteCallee, MethodArgs } from './src/main/ets/remote/RemoteCallee';

export { RemoteCaller } from './src/main/ets/remote/RemoteCaller';

export type { RemoteInterceptor } from './src/main/ets/remote/RemoteInterceptor';

export { checkNumber, checkPath, checkNonNull } from './src/main/ets/remote/ParamChecker';

export { logPreInterceptor, logPostInterceptor } from './src/main/ets/remote/RemoteLogInterceptor';

export { TsLog, TsLog as Logger } from './src/main/ets/log/TsLog';

export { JsonUtils } from './src/main/ets/utils/JsonUtils';

export { CloudUtils } from './src/main/ets/utils/CloudUtils';

export type { ClassConstructor,
  MapType,
  MapTypes,
  OhosMapTypes,
  ArrayType,
  SetType,
  OhosListTypes,
  PrimitiveType,
  NonPrimitiveType,
  AnyType,
  AnyFunction,
  Entry,
  NullableType,
  TsContext,
} from './src/main/ets/utils/Types';

export { ArrayUtils } from './src/main/ets/utils/ArrayUtils';

export { ObjectUtils } from './src/main/ets/utils/ObjectUtils';

export { BundleUtils } from './src/main/ets/utils/BundleUtils';

export { MapUtils } from './src/main/ets/utils/MapUtils';

export { ContextUtil } from './src/main/ets/utils/ContextUtil';

export { FileUtil } from './src/main/ets/utils/FileUtil';

export { StringUtils } from './src/main/ets/utils/StringUtils';

export { TextCodec } from './src/main/ets/utils/TextCodec';

export { serviceRegister } from './src/main/ets/service/ServiceRegister';

export { singleton, Singleton } from './src/main/ets/service/Singleton';

export type { InstanceProducer } from './src/main/ets/service/Singleton';

export { EventEmitter } from './src/main/ets/event/EventEmitter';