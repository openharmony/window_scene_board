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

export class HiSysCommonParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public TAG_NAME: string = '';
  public FUNC: string = '';
}

export class HiSysSaveParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public TAG_NAME: string = '';
  public FUNC: string = '';
  public APP_NUM: number = 0;
  public APP_NAMES: string = '';
}

export class HiSysClickAppParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public TAG_NAME: string = '';
  public FUNC: string = '';
  public APP_NAME: string = '';
}