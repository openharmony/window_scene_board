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

import { Driver, ON } from '@ohos.UiTest'
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';

const TAG: string = 'LabelTest';
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function startAbility(bundleName: string, abilityName: string) {
  await abilityDelegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`).then(result => {
    console.info(`${TAG}, start abilityFinished: ${result}`)
  }).catch((err : BusinessError) => {
    console.error(`${TAG}, start abilityFailed: ${err}`)
  })
}

export default function LabelTest() {
  describe('LabelTest', () => {
    // 定义Driver类
    let driver = Driver.create();

    /**
     * 下拉控制中心
     */
    it('controller_swipedown', 0, async (done: Function) => {
      try {
        hilog.info(0x0, TAG, 'controller_swipedown start');
        await driver.swipe(850, 10, 850, 400, 2000);
        expect(true).assertTrue();
        hilog.info(0x0, TAG, 'controller_swipedown end');
        await driver.delayMs(3000);
        expect(true).assertTrue();
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'controller_swipedown' + e.message);
      }
    })

    /**
     * 控制-播放暂停
     */
    it('controller_play', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_play start');
        let controllerPlay = await driver.findComponent(ON.id('control_center_media_card_play_or_pause'));
        expect(controllerPlay).not().assertUndefined();
        await controllerPlay.click();
        hilog.info(0x0, TAG, 'controller_play end');
        await driver.delayMs(5000);
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_play' + e.message);
      }
    })

    /**
     * 控制-上一首
     */
    it('controller_playprevious', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_playprevious start');
        let controllerAudioPlayPrevious = await driver.findComponent(ON.id('control_center_media_card_previous'));
        expect(controllerAudioPlayPrevious).not().assertUndefined();
        await controllerAudioPlayPrevious.click();
        hilog.info(0x0, TAG, 'controller_playprevious end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_playprevious' + e.message);
      }
    })

    /**
     * 控制-播放暂停
     */
    it('controller_pause', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_pause start');
        let controllerPlay = await driver.findComponent(ON.id('control_center_media_card_play_or_pause'));
        expect(controllerPlay).not().assertUndefined();
        await controllerPlay.click();
        hilog.info(0x0, TAG, 'controller_pause end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_pause' + e.message);
      }
    })

    /**
     * 控制-暂停--播放
     */
    it('controller_pauseplay', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_pauseplay start');
        let controllerPlay = await driver.findComponent(ON.id('control_center_media_card_play_or_pause'));
        expect(controllerPlay).not().assertUndefined();
        await controllerPlay.click();
        hilog.info(0x0, TAG, 'controller_pauseplay end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_pauseplay' + e.message);
      }
    })

    /**
     * 控制-下一首
     */
    it('controller_playnext', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_playnext start');
        let controllerAudioPlayNext = await driver.findComponent(ON.id('control_center_media_card_next'));
        expect(controllerAudioPlayNext).not().assertUndefined();
        await controllerAudioPlayNext.click();
        hilog.info(0x0, TAG, 'controller_playnext end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_playnext' + e.message);
      }
    })

    /**
     * 右滑至通知栏
     */
    it('controller_swiperight', 0, async (done: Function) => {
      try {
        await driver.delayMs(5000);
        hilog.info(0x0, TAG, 'controller_swiperight start');
        await driver.swipe(300, 300, 850, 300, 2000);
        hilog.info(0x0, TAG, 'controller_swiperight end');
        await driver.delayMs(3000);
        expect(true).assertTrue();
        done()
      } catch(e) {
        hilog.info(0x0, TAG, 'controller_swiperight' + e.message);
      }
    })

    /**
     * 通知栏-点击投音按钮 -展开
     */
    it('item_SwitchIcon_expand', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_SwitchIcon_expand start');
        let controllerSwitchIcon = await driver.findComponent(ON.id('SwitchDeviceButton_Image_outputType'));
        expect(controllerSwitchIcon).not().assertUndefined();
        await controllerSwitchIcon.click();
        hilog.info(0x0, TAG, 'item_SwitchIcon_expand end');
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'item_SwitchIcon_expand' + e.message);
      }
    })

    /**
     * 通知栏-点击投音按钮 -消失
     */
    it('item_SwitchIcon_collapse', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_SwitchIcon_collapse start');
        let controllerSwitchIcon = await driver.findComponent(ON.id('SwitchDeviceButton_Image_outputType'));
        expect(controllerSwitchIcon).not().assertUndefined();
        await controllerSwitchIcon.click();
        hilog.info(0x0, TAG, 'item_SwitchIcon_collapse end');
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'item_SwitchIcon_collapse' + e.message);
      }
    })

    /**
     * 通知栏-进度
     */
    it('item_Progress', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_Progress start');
        let controllerProgress = await driver.findComponent(ON.id('media_playback_controller_item_progress'));
        expect(controllerProgress).not().assertUndefined();
        await controllerProgress.click();
        hilog.info(0x0, TAG, 'item_Progress end');
        await driver.delayMs(3000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_Progress' + e.message);
      }
    })

    /**
     * 通知栏-循环模式 1
     */
    it('item_LoopMode_one', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_LoopMode_one start');
        let itemLoopMode = await driver.findComponent(ON.id('buttonGroupLoopButton'));
        expect(itemLoopMode).not().assertUndefined();
        await itemLoopMode.click();
        hilog.info(0x0, TAG, 'item_LoopMode_one end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_LoopMode_one' + e.message);
      }
    })

    /**
     * 通知栏-循环模式 2
     */
    it('item_LoopMode_two', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_LoopMode_two start');
        let itemLoopMode = await driver.findComponent(ON.id('buttonGroupLoopButton'));
        expect(itemLoopMode).not().assertUndefined();
        await itemLoopMode.click();
        hilog.info(0x0, TAG, 'item_LoopMode_two end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_LoopMode_two' + e.message);
      }
    })

    /**
     * 通知栏-循环模式 3
     */
    it('item_LoopMode_three', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_LoopMode_three start');
        let itemLoopMode = await driver.findComponent(ON.id('buttonGroupLoopButton'));
        expect(itemLoopMode).not().assertUndefined();
        await itemLoopMode.click();
        hilog.info(0x0, TAG, 'item_LoopMode_three end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_LoopMode_three' + e.message);
      }
    })

    /**
     * 通知栏-上一首
     */
    it('item_Previous', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_Previous start');
        let itemPrevious = await driver.findComponent(ON.id('notification_media_card_previous'));
        expect(itemPrevious).not().assertUndefined();
        await itemPrevious.click();
        hilog.info(0x0, TAG, 'item_Previous end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_Previous' + e.message);
      }
    })

    /**
     * 通知栏-暂停
     */
    it('item_pause', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_pause start');
        let itemPause = await driver.findComponent(ON.id('notification_media_card_play_or_pause'));
        expect(itemPause).not().assertUndefined();
        await itemPause.click();
        hilog.info(0x0, TAG, 'item_pause end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_pause' + e.message);
      }
    })

    /**
     * 通知栏-播放暂停
     */
    it('item_play', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_play start');
        let itemPlay = await driver.findComponent(ON.id('notification_media_card_play_or_pause'));
        expect(itemPlay).not().assertUndefined();
        await itemPlay.click();
        hilog.info(0x0, TAG, 'item_play end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_play' + e.message);
      }
    })

    /**
     * 通知栏-下一首
     */
    it('item_next', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_next start');
        let itemNext = await driver.findComponent(ON.id('notification_media_card_next'));
        expect(itemNext).not().assertUndefined();
        await itemNext.click();
        hilog.info(0x0, TAG, 'item_next end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_next' + e.message);
      }
    })

    /**
     * 通知栏-收藏
     */
    it('item_favor', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_favor start');
        let buttonGroupFavorButton = await driver.findComponent(ON.id('buttonGroupFavorButton'));
        expect(buttonGroupFavorButton).not().assertUndefined();
        await buttonGroupFavorButton.click();
        hilog.info(0x0, TAG, 'item_favor end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_favor' + e.message);
      }
    })

    /**
     * 通知栏-收藏
     */
    it('item_favor_one', 0, async (done: Function) => {
      try {
        await driver.delayMs(5000);
        hilog.info(0x0, TAG, 'item_favor_one start');
        let buttonGroupFavorButton = await driver.findComponent(ON.id('buttonGroupFavorButton'));
        expect(buttonGroupFavorButton).not().assertUndefined();
        await buttonGroupFavorButton.click();
        hilog.info(0x0, TAG, 'item_favor_one end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_favor_one' + e.message);
      }
    })

    /**
     * 左滑返回控制中心
     */
    it('controller_swipeleft', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_swipeleft start');
        await driver.swipe(850, 300, 100, 300, 2000);
        expect(true).assertTrue();
        hilog.info(0x0, TAG, 'controller_swipeleft end');
        await driver.delayMs(3000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_swipeleft' + e.message);
      }
    })

    /**
     * 进入播控中心
     */
    it('media_card', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_card start');
        let mediaCard = await driver.findComponent(ON.id('media_card'));
        await mediaCard.click();
        expect(true).assertTrue();
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_card end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_card' + e.message);
      }
    })
  })
}