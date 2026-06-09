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

const TAG: string = 'MediaInfoProviderTest';
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function stopApplication(bundleName: string) {
  await abilityDelegator.executeShellCommand(`aa force-stop ${bundleName} `).then(result => {
    console.info(`${TAG}, stop application finished: ${result}`)
  }).catch((err : BusinessError) => {
    console.error(`${TAG},stop application failed: ${err}`)
  })
}

export default function MediaInfoProviderTest() {
  describe('MediaInfoProviderTest', () => {
    let driver = Driver.create();

    /**
     * 点击进度条
     */
    it('media_mediaProcessEnd', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_mediaProcessEnd start');
        let mediaProcessEnd = await driver.findComponent(ON.id('mediaProcessEnd'));
        expect(mediaProcessEnd).not().assertUndefined();
        await mediaProcessEnd.click();
        hilog.info(0x0, TAG, 'media_mediaProcessEnd end');
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'media_mediaProcessEnd' + e.message);
      }
    })

    /**
     * 循环模式 1
     */
    it('media_loopmode', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_loopmode start');
        let mediaPlayLoopmode = await driver.findComponent(ON.id('buttonLoopModeEnd'));
        expect(mediaPlayLoopmode).not().assertUndefined();
        await mediaPlayLoopmode.click();
        hilog.info(0x0, TAG, 'media_loopmode end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_loopmode' + e.message);
      }
    })

    /**
     * 循环模式 2
     */
    it('media_loopmode_one', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_loopmode_one start');
        let mediaPlayLoopmode = await driver.findComponent(ON.id('buttonLoopModeEnd'));
        expect(mediaPlayLoopmode).not().assertUndefined();
        await mediaPlayLoopmode.click();
        hilog.info(0x0, TAG, 'media_loopmode_one end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_loopmode_one' + e.message);
      }
    })

    /**
     * 循环模式 3
     */
    it('media_loopmode_two', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_loopmode_two start');
        let mediaPlayLoopmode = await driver.findComponent(ON.id('buttonLoopModeEnd'));
        expect(mediaPlayLoopmode).not().assertUndefined();
        await mediaPlayLoopmode.click();
        hilog.info(0x0, TAG, 'media_loopmode_two end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_loopmode_two' + e.message);
      }
    })

    /**
     * 上一首
     */
    it('media_previous', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_previous start');
        let mediaPlayPrevious = await driver.findComponent(ON.id('media_previous_No.0'));
        expect(mediaPlayPrevious).not().assertUndefined();
        await mediaPlayPrevious.click();
        hilog.info(0x0, TAG, 'media_previous end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_previous' + e.message);
      }
    })

    /**
     * 暂停
     */
    it('media_pause', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_pause start');
        let mediaPause = await driver.findComponent(ON.id('media_play_pause_No.0'));
        expect(mediaPause).not().assertUndefined();
        await mediaPause.click();
        hilog.info(0x0, TAG, 'media_pause end');
        done()
      } catch(e) {
        hilog.info(0x0, TAG, 'media_pause' + e.message);
      }
    })

    /**
     * 播放
     * */
    it('media_play', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_play start');
        let mediaPlay = await driver.findComponent(ON.id('media_play_pause_No.0'));
        expect(mediaPlay).not().assertUndefined();
        await mediaPlay.click();
        hilog.info(0x0, TAG, 'media_play end');
        done()
      } catch(e) {
        hilog.info(0x0, TAG, 'media_play' + e.message);
      }
    })

    /**
     * 下一首
     * */
    it('media_next', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_next start');
        let mediaPlayNext = await driver.findComponent(ON.id('media_next_No.0'));
        expect(mediaPlayNext).not().assertUndefined();
        await mediaPlayNext.click();
        hilog.info(0x0, TAG, 'media_next end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_next' + e.message);
      }
    })

    /**
     * 收藏-取消
     */
    it('media_favor_one', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_favor_one start');
        let mediaPlayFavor = await driver.findComponent(ON.id('buttonFavorEnd'));
        expect(mediaPlayFavor).not().assertUndefined();
        await mediaPlayFavor.click();
        hilog.info(0x0, TAG, 'media_favor_one end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_favor_one' + e.message);
      }
    })

    /**
     * 收藏-取消
     */
    it('media_favor_two', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_favor_two start');
        let mediaPlayFavor = await driver.findComponent(ON.id('buttonFavorEnd'));
        expect(mediaPlayFavor).not().assertUndefined();
        await mediaPlayFavor.click();
        hilog.info(0x0, TAG, 'media_favor_two end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_favor_two' + e.message);
      }
    })

    /**
     * 音量条
     */
    it('media_volumeEnd', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_volumeEnd start');
        let mediaVolumeEnd = await driver.findComponent(ON.id('mediaVolumeEnd'));
        expect(mediaVolumeEnd).not().assertUndefined();
        await mediaVolumeEnd.click();
        hilog.info(0x0, TAG, 'media_volumeEnd end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_volumeEnd' + e.message);
      }
    })

    /**
     * 点击歌单播放
     */
    it('media_historicalList', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_historicalList start');
        let historicalList = await driver.findComponent(ON.id('historical_list_item2'));
        expect(historicalList).not().assertUndefined();
        await historicalList.click();
        hilog.info(0x0, TAG, 'media_historicalList end');
        await driver.delayMs(6000);
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'media_historicalList' + e.message);
      }
    })

    /**
     * 跳进应用
     */
    it('media_jumpAppImage', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_jumpAppImage start');
        let startAimApp = await driver.findComponent(ON.id('media_music_info_No.0'));
        expect(startAimApp).not().assertUndefined();
        await startAimApp.click();
        hilog.info(0x0, TAG, 'media_jumpAppImage end');
        await driver.delayMs(3000);
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'media_jumpAppImage' + e.message);
      }
    })

    /**
     * kill com.ohos.music
     */
    it('media_killApp', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_killApp start');
        await stopApplication('com.ohos.music');
        expect(true).assertTrue();
        hilog.info(0x0, TAG, 'media_killApp end');
        await driver.delayMs(5000);
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'media_killApp' + e.message);
      }
    })
  })
}