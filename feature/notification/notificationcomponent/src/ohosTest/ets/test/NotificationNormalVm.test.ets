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

import { beforeEach, describe, expect, it, Level, MockKit, TestType, when } from '@ohos/hypium';

import { NtfMultiLineContent } from '@ohos/systemuicommon';
import { NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { notificationManager } from '@kit.NotificationKit';
import { WantAgent, wantAgent } from '@kit.AbilityKit';
import { NotificationNormalVm } from '../../../main/ets/viewmodel/NotificationNormalVm';
import { NotificationPanelVmInjector } from '../../../main/ets/viewmodel/NotificationPanelVmInjector';

export default function NotificationNormalVmTest() {
  describe('NotificationNormalVmTest', () => {
    let wantAgentInfo: wantAgent.WantAgentInfo;
    let lineWantAgent: WantAgent;
    beforeEach(() => {
      // 构造wantAgent数据数组
      wantAgentInfo = {
        wants: [{ bundleName: 'com.ohos.health', abilityName: "MainAbility" }],
        actionType: wantAgent.OperationType.START_ABILITY,
        requestCode: 110
      }
      lineWantAgent = wantAgent.getWantAgent(wantAgentInfo);
    });

    it('linesTextIsValid', TestType.FUNCTION | Level.LEVEL0, () => {
      // 构造榜单多行文本通知内容
      let multiLineContent: notificationManager.NotificationMultiLineContent = {
        title: '榜单通知标题',
        text: '榜单通知内容',
        briefText: '榜单通知摘要',
        longTitle: '榜单通知长文本标题',
        lines: ['运动健康'],
        lineWantAgents: [lineWantAgent]
      };
      let ntfMultiContent: NtfMultiLineContent = new NtfMultiLineContent(multiLineContent);

      // 构造通知
      let ntf: NormalNotification = new NormalNotification();
      ntf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE;
      ntf.content = ntfMultiContent;

      // 构造 NotificationNormalVm
      let ntfNormalVm: NotificationNormalVm = new NotificationNormalVm(new NotificationPanelVmInjector(), ntf);

      expect((ntfNormalVm as object)['linesTextIsValid']()).assertTrue();
    });

    it('hasEmojiInMultiLines', TestType.FUNCTION | Level.LEVEL0, () => {
      // 构造榜单多行文本通知内容
      let multiLineContent: notificationManager.NotificationMultiLineContent = {
        title: 'hotTopTitle',
        text: 'hotTopContent',
        briefText: 'hotTopBrief',
        longTitle: 'hotTopLongTitle',
        lines: ['运动健康😊health'],
        lineWantAgents: [lineWantAgent]
      };
      let ntfMultiContent: NtfMultiLineContent = new NtfMultiLineContent(multiLineContent);

      // 构造通知
      let ntf: NormalNotification = new NormalNotification();
      ntf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE;
      ntf.content = ntfMultiContent;

      // 构造 NotificationNormalVm
      let ntfNormalVm: NotificationNormalVm = new NotificationNormalVm(new NotificationPanelVmInjector(), ntf);

      expect((ntfNormalVm as object)['hasEmojiInMultiLines']()).assertTrue();
    });

    it('onClickMultiContent', TestType.FUNCTION | Level.LEVEL0, () => {
      // 构造榜单多行文本通知内容
      let multiLineContent: notificationManager.NotificationMultiLineContent = {
        title: 'hotTopTitle标题',
        text: 'hotTopContent内容',
        briefText: 'hotTopBrief摘要',
        longTitle: 'hotTopLongTitle标题',
        lines: ['运动健康😊health'],
        lineWantAgents: [lineWantAgent]
      };
      let ntfMultiContent: NtfMultiLineContent = new NtfMultiLineContent(multiLineContent);

      // 构造通知
      let ntf: NormalNotification = new NormalNotification();
      ntf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE;
      ntf.content = ntfMultiContent;

      // 构造 NotificationNormalVm
      let ntfNormalVm: NotificationNormalVm = new NotificationNormalVm(new NotificationPanelVmInjector(), ntf);

      // mock 点击事件
      let mocker: MockKit = new MockKit();
      let mockOnClick: Function = mocker.mockFunc(ntfNormalVm, ntfNormalVm.onClick);
      when(mockOnClick)().afterReturnNothing;

      // test onClickMultiContent
      let title: string = '运动健康😊health';
      let index: number = 0;
      expect((ntfNormalVm as object)['onClickMultiContent'](title, index)).assertPromiseIsResolved();
    });
  })
}