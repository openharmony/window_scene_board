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
import { LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { UserList } from '../../userspanel/component/UserList/UserList';
import { UserTextBuilder } from '../../userspanel/component/UserText/UserText';
import { EnterpriseSpacePanelVM } from '../viewModel/EnterpriseSpacePanelViewModel';

const TAG = 'UserPanel-EnterpriseSpacePanel-Index';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct EnterpriseSpacePanel {
  @ObjectLink vm: EnterpriseSpacePanelVM;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  @Builder
  titleBuilder() {
    Row() {
      UserTextBuilder(this.vm.title, this.vm.titleStyle)
    }
    .width('100%')
    .height(52)
    .padding({
      top: 12.5,
      bottom: 12.5,
      start: LengthMetrics.vp(22)
    })
  }

  build() {
    Column() {
      this.titleBuilder()
      UserList({ list: this.vm.userList })
    }
    .padding(4)
  }
}