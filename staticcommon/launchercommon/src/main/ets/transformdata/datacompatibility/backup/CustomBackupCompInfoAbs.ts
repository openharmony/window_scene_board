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
import { relationalStore } from '@kit.ArkData';
import { RestoreCompatibilityInfo } from '../model/RestoreCompatibilityInfo';

/**
 * 备份端生成兼容性数据库信息，供恢复端使用
 * 若由其它业务特性（非数据库版本升级），导致需要做兼容性数据处理，则继承此类实现兼容数据生成
 */
export abstract class CustomBackupCompInfoAbs {
  // 是否需要做数据兼容性备份，由各业务自定义实现
  public abstract isNeedBackUpCompInfo(compInfo: RestoreCompatibilityInfo): Promise<boolean>;

  // 备份端：生成兼容性数据
  public abstract backupCompInfo(compInfo: RestoreCompatibilityInfo,
    backupStore: relationalStore.RdbStore): Promise<void>;
}