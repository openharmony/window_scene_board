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
 * 克隆备份兼容性处理数据：该数据内容会从恢复端（新）机带回给备份端（旧机）
 * 各业务若有诉求，可在此类中扩展自身业务需返回的属性
 */
export class RestoreCompatibilityInfo {
  // 数据库版本号
  public dbVersion: number = 0;

  public setDbVersion(dbVersion: number): RestoreCompatibilityInfo {
    this.dbVersion = dbVersion;
    return this;
  }

  public getDbVersion(): number {
    return this.dbVersion;
  }
}