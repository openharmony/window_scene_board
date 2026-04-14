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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LiveDropdownVmInjector } from '../LiveDropdownVmInjector';
import { LiveCardDropdownConsumerView } from './LiveCardDropdownConsumerView';

if (DeviceHelper.is2In1DevicePcType()) {
  LiveDropdownVmInjector.instance.init();
}

/**
 * 通知中心1.0面板中的实况卡片
 */
@ComponentV2
export struct LiveCardDropdownView {
  // 通知1.0场景，在这里提供liveVmInjector。 2.0直接引用子组件LiveCardDropdownConsumerView，避免liveVmInjector覆盖
  @Provider() liveVmInjector: LiveDropdownVmInjector = LiveDropdownVmInjector.instance;
  @Param @Require hashCode: string;
  @Param @Require displayButtonsHashCode: string;

  build() {
    LiveCardDropdownConsumerView({
      live: this.liveVmInjector.liveMap.get(this.hashCode),
      displayButtonsHashCode: this.displayButtonsHashCode
    })
  }
}