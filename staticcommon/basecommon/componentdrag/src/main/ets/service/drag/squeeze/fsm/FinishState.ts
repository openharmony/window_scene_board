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

import { SqueezeParams } from '../../common/type/SqueezeTypes';
import { State } from '../../common/utils/statemachine/StateMachine';
import { SqueezeStateType } from './SqueezeMachineContext';

/**
 * 结束状态实现
 */
export class FinishState extends State {
  constructor(userParams: SqueezeParams) {
    super(SqueezeStateType.FINISH_STATE);
  }
}