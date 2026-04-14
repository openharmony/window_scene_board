/**
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
 * 兼容数据
 */
export class BackupConstants {
  public static readonly BASE_DB_VERSION: number = 22;
  public static readonly HM_LAUNCHER_DB: string = 'Launcher.db';
  public static readonly HM_LAUNCHER_SHM: string = 'Launcher.db-shm';
  public static readonly HM_LAUNCHER_WAL: string = 'Launcher.db-wal';

  public static readonly HM_LAUNCHER_COMP_DB: string = 'Launcher_comp.db';
  public static readonly HM_LAUNCHER_COMP_SHM: string = 'Launcher_comp.db-shm';
  public static readonly HM_LAUNCHER_COMP_WAL: string = 'Launcher_comp.db-wal';
}