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
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';

/**
 *提供样机桌面恢复功能
 *
 * @since2024-04-11
 */
export class RestoringDesktopLayout implements IExecutor {
  async execute(extra?: object): Promise<string> {
    return Response.SUCCESS;
  }
}

