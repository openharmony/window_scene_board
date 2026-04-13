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

import { BaseController } from '@ohos/controlcentercommon/Index';
import { SingletonHelper } from '@ohos/basicutils';
import SoundToggleData from '../common/SoundToggleData';
import { soundSubPageController } from './SoundSubPageLayoutController';

const TAG = 'Model.SoundToggleController';

export class SoundToggleController extends BaseController<SoundToggleData> {
  private data: SoundToggleData = new SoundToggleData();

  constructor() {
    super();
    this.onStart();
  }

  getData() {
    return this.data;
  }

  isAvailable(): boolean {
    return true;
  }

  handleClick(): boolean {
    this.jumpToSubPage();
    return true;
  }

  handleLongClick(): boolean {
    this.jumpToSubPage();
    return true;
  }

  jumpToSubPage() {
    soundSubPageController.showWindow();
  }
}

const toggleController: SoundToggleController = SingletonHelper.getInstance(SoundToggleController, TAG);

export default toggleController as SoundToggleController;