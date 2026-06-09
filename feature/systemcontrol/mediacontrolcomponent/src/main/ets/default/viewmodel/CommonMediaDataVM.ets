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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CommonMediaController } from '../Controller/CommonMediaController';
import { BasicMediaData, BasicMediaVM } from './BasicMediaVM';
import { CommonMediaData } from './CommonMediaData';

const TAG = 'CommonMediaDataVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export class CommonMediaDataVM extends BasicMediaVM {
  protected data: CommonMediaData;
  protected controller: CommonMediaController;

  /*
    创建一个新的基础播控VM，并完成数据与控制器的初始化
   */
  public static createInstance(): CommonMediaDataVM {
    let vm = new CommonMediaDataVM();
    return vm;
  }

  constructor() {
    super();
    this.data = new CommonMediaData();
    this.controller = new CommonMediaController(this.data);
  }
}