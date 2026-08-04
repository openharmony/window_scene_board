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

const TAG: string = 'MediaControllerVideoTest';
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function startAbility(bundleName: string, abilityName: string) {
  await abilityDelegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`).then(result => {
    console.info(`${TAG}, start abilityFinished: ${result}`)
  }).catch((err : BusinessError) => {
    console.error(`${TAG}, start abilityFailed: ${err}`)
  })
}

async function stopApplication(bundleName: string) {
  await abilityDelegator.executeShellCommand(`aa force-stop ${bundleName} `).then(result => {
    console.info(`${TAG}, stop application finished: ${result}`)
  }).catch((err : BusinessError) => {
    console.error(`${TAG}, stop application failed: ${err}`)
  })
}

export default function MediaControllerVideoTest() {
  describe('MediaControllerVideoTest', () => {
    // 定义Driver类
    let driver = Driver.create();

    /**
     * 打开视频
     */
    it('open_app_video', 0, async (done: Function) => {
      try {
        hilog.info(0x0, TAG, 'open_himovie begin');
        await startAbility('com.ohos.himovie', 'MainAbility');
        hilog.info(0x0, TAG, 'open_himovie end');
        await driver.delayMs(8000);

        let openVideo = await driver.findComponent(ON.id('ImageTextSlimCard.Image.imageUrl'));
        await openVideo.click();
        await driver.delayMs(15000);
        expect(true).assertTrue();
        done()
      } catch(e) {
        hilog.info(0x0, TAG, 'open_app_video' + e.message);
      }
    })

    /**
     * 下拉通知中心
     */
    it('item_video_swipedown', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_video_swipedown start');
        await driver.swipe(100, 10, 100, 400, 2000);
        hilog.info(0x0, TAG, 'item_video_swipedown end');
        await driver.delayMs(5000);
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'item_video_swipedown' + e.message);
      }
    })

    /**
     * 通知栏-点击投音按钮 -展开
     */
    it('item_video_switchIcon_open', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_video_switchIcon_open start');
        let controllerSwitchIcon = await driver.findComponent(ON.id('SwitchDeviceButton_Image_outputType'));
        expect(controllerSwitchIcon).not().assertUndefined();
        await controllerSwitchIcon.click();
        hilog.info(0x0, TAG, 'item_video_switchIcon_open end');
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'item_video_switchIcon_open' + e.message);
      }
    })

    /**
     * 通知栏-点击投音按钮 -消失
     */
    it('item_video_switchIcon_close', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_video_switchIcon_close start');
        let controllerSwitchIcon = await driver.findComponent(ON.id('SwitchDeviceButton_Image_outputType'));
        expect(controllerSwitchIcon).not().assertUndefined();
        await controllerSwitchIcon.click();
        hilog.info(0x0, TAG, 'item_video_switchIcon_close end');
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'item_video_switchIcon_close' + e.message);
      }
    })

    /**
     * 通知栏-进度
     * */
    it('item_video_Progress', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_video_Progress start');
        let controllerProgress = await driver.findComponent(ON.id('media_playback_controller_item_progress'));
        expect(controllerProgress).not().assertUndefined();
        await controllerProgress.click();
        hilog.info(0x0, TAG, 'item_video_Progress end');
        await driver.delayMs(3000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_video_Progress' + e.message);
      }
    })

    /**
     * 通知栏-快退
     */
    it('item_rewind', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_rewind start');
        let controllerRewind = await driver.findComponent(ON.id('notification_media_card_rewind'));
        expect(controllerRewind).not().assertUndefined();
        await controllerRewind.click();
        hilog.info(0x0, TAG, 'item_rewind end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_rewind' + e.message);
      }
    })

    /**
     * 通知栏-播放暂停
     * */
    it('item_video_pause', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_video_pause start');
        let itemPlay = await driver.findComponent(ON.id('notification_media_card_play_or_pause'));
        expect(itemPlay).not().assertUndefined();
        await itemPlay.click();
        hilog.info(0x0, TAG, 'item_video_pause end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_video_pause' + e.message);
      }
    })

    /**
     * 通知栏-播放暂停
     * */
    it('item_video_play', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_video_play start');
        let itemPlay = await driver.findComponent(ON.id('notification_media_card_play_or_pause'));
        expect(itemPlay).not().assertUndefined();
        await itemPlay.click();
        hilog.info(0x0, TAG, 'item_video_play end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_video_play' + e.message);
      }
    })

    /**
     * 通知栏-下一首
     * */
    it('item_video_next', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_video_next start');
        let itemNext = await driver.findComponent(ON.id('notification_media_card_next'));
        expect(itemNext).not().assertUndefined();
        await itemNext.click();
        hilog.info(0x0, TAG, 'item_video_next end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_video_next' + e.message);
      }
    })

    /**
     * 通知栏-快进
     */
    it('item_fastForward', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'item_fastForward start');
        let itemFastForward = await driver.findComponent(ON.id('notification_media_card_fast_forward'));
        expect(itemFastForward).not().assertUndefined();
        await itemFastForward.click();
        hilog.info(0x0, TAG, 'item_fastForward end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'item_fastForward' + e.message);
      }
    })

    /**
     * 左滑返回控制中心
     */
    it('controller_swpieleft', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_swpieleft start');
        await driver.swipe(850, 300, 100, 300, 2000);
        expect(true).assertTrue();
        hilog.info(0x0, TAG, 'controller_swpieleft end');
        await driver.delayMs(3000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_swpieleft' + e.message);
      }
    })

    /**
     * 控制-播放暂停
     * */
    it('controller_video_play', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_video_play start');
        let controllerPlay = await driver.findComponent(ON.id('control_center_media_card_play_or_pause'));
        expect(controllerPlay).not().assertUndefined();
        await controllerPlay.click();
        hilog.info(0x0, TAG, 'controller_video_play end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_video_play' + e.message);
      }
    })

    /**
     * 控制-播放暂停
     * */
    it('controller_video_pause', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_video_pause start');
        let controllerPlay = await driver.findComponent(ON.id('control_center_media_card_play_or_pause'));
        expect(controllerPlay).not().assertUndefined();
        await controllerPlay.click();
        hilog.info(0x0, TAG, 'controller_video_pause end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_video_pause' + e.message);
      }
    })

    /**
     * 控制-快进
     */
    it('controller_fastforward', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_fastforward start');
        let controllerFastForward = await driver.findComponent(ON.id('control_center_media_card_fastForward'));
        expect(controllerFastForward).not().assertUndefined();
        await controllerFastForward.click();
        hilog.info(0x0, TAG, 'controller_fastforward end');
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_fastforward' + e.message);
      }
    })

    /**
     * 控制-快退
     */
    it('controller_rewind', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'controller_rewind start');
        let controllerRewind = await driver.findComponent(ON.id('control_center_media_card_rewind'));
        expect(controllerRewind).not().assertUndefined();
        await controllerRewind.click();
        hilog.info(0x0, TAG, 'controller_rewind end');
        await driver.delayMs(3000);
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_rewind' + e.message);
      }
    })

    /**
     * 点击投音按钮-进入播控中心
     */
    it('controller_switchIconStart', 0, async (done: Function) => {
      try {
        await driver.delayMs(5000);
        hilog.info(0x0, TAG, 'controller_switchIconStart start');
        let switchIconStart = await driver.findComponent(ON.id('control_center_media_card_switch'));
        expect(switchIconStart).not().assertUndefined();
        await switchIconStart.click();
        hilog.info(0x0, TAG, 'controller_switchIconStart end');
        await driver.delayMs(3000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'controller_switchIconStart' + e.message);
      }
    })

    /**
     * 点击进度条
     */
    it('media_video_mediaProcessEnd', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_mediaProcessEnd start');
        let mediaProcessEnd = await driver.findComponent(ON.id('mediaProcessEnd'));
        expect(mediaProcessEnd).not().assertUndefined();
        await mediaProcessEnd.click();
        hilog.info(0x0, TAG, 'media_video_mediaProcessEnd end');
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'media_video_mediaProcessEnd' + e.message);
      }
    })


    /**
     * 播控中心-快进
     */
    it('media_video_fastforward', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_fastforward start');
        let mediaFastforWard = await driver.findComponent(ON.id('media_videofastforward_No.0'));
        expect(mediaFastforWard).not().assertUndefined();
        await mediaFastforWard.click();
        hilog.info(0x0, TAG, 'media_video_fastforward end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_fastforward' + e.message);
      }
    })

    /**
     * 播控中心-快退
     */
    it('media_video_rewind', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_rewind start');
        let mediaRewind = await driver.findComponent(ON.id('media_rewind_No.0'));
        expect(mediaRewind).not().assertUndefined();
        await mediaRewind.click();
        hilog.info(0x0, TAG, 'media_video_rewind end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_rewind' + e.message);
      }
    })

    /**
     * 播放暂停
     */
    it('media_video_play', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_play start');
        let mediaPlay = await driver.findComponent(ON.id('media_play_pause_No.0'));
        expect(mediaPlay).not().assertUndefined();
        await mediaPlay.click();
        hilog.info(0x0, TAG, 'media_video_play end');
        done()
      } catch(e) {
        hilog.info(0x0, TAG, 'media_video_play' + e.message);
      }
    })

    /**
     * 播放暂停
     * */
    it('media_video_pause', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_pause start');
        let mediaPlay = await driver.findComponent(ON.id('media_play_pause_No.0'));
        expect(mediaPlay).not().assertUndefined();
        await mediaPlay.click();
        hilog.info(0x0, TAG, 'media_video_pause end');
        done()
      } catch(e) {
        hilog.info(0x0, TAG, 'media_video_pause' + e.message);
      }
    })

    /**
     * 下一集
     * */
    it('media_video_next', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_next start');
        let mediaPlayNext = await driver.findComponent(ON.id('media_next_No.0'));
        expect(mediaPlayNext).not().assertUndefined();
        await mediaPlayNext.click();
        hilog.info(0x0, TAG, 'media_video_next end');
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_next' + e.message);
      }
    })

    /**
     * 播控中心-可信设备1
     */
    it('media_video_trustDeviceItem1', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_trustDeviceItem1 start');
        let trustDeviceItem = await driver.findComponent(ON.id('trustDeviceItem.1'));
        expect(trustDeviceItem).not().assertUndefined();
        await trustDeviceItem.click();
        hilog.info(0x0, TAG, 'media_video_trustDeviceItem1 end');
        await driver.delayMs(5000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_trustDeviceItem1' + e.message);
      }
    })

    /**
     * 播控中心-点击本机0
     */
    it('media_video_trustDeviceItem0', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_trustDeviceItem0 start');
        let trustDeviceItem = await driver.findComponent(ON.id('trustDeviceItem.0'));
        expect(trustDeviceItem).not().assertUndefined();
        await trustDeviceItem.click();
        hilog.info(0x0, TAG, 'media_video_trustDeviceItem0 end');
        await driver.delayMs(5000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_trustDeviceItem0' + e.message);
      }
    })

    /**
     * 播控中心-点击更多设备
     */
    it('media_video_moredevice', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_moredevice start');
        let mediaMoreDevice = await driver.findComponent(ON.id('mediaMoreDevice'));
        expect(mediaMoreDevice).not().assertUndefined();
        await mediaMoreDevice.click();
        hilog.info(0x0, TAG, 'media_video_moredevice end');
        await driver.delayMs(5000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_moredevice' + e.message);
      }
    })

    /**
     * 播控中心-非可信设备
     */
    it('media_video_deviceNotTrust', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_deviceNotTrust start');
        let deviceNotTrust = await driver.findComponent(ON.id('deviceNotTrust.0'));
        expect(deviceNotTrust).not().assertUndefined();
        await deviceNotTrust.click();
        hilog.info(0x0, TAG, 'media_video_deviceNotTrust end');
        await driver.delayMs(8000);
        done();
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_deviceNotTrust' + e.message);
      }
    })

    /**
     * 播控中心-点击投音按钮
     */
    it('media_video_mediaSwitchIcon', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_video_mediaSwitchIcon start');
        let mediaSwitchIcon = await driver.findComponent(ON.id('mediaSwitchIcon'));
        expect(mediaSwitchIcon).not().assertUndefined();
        await mediaSwitchIcon.click();
        hilog.info(0x0, TAG, 'media_video_mediaSwitchIcon end');
        await driver.delayMs(5000);
        done()
      }  catch(e) {
        hilog.info(0x0, TAG, 'media_video_mediaSwitchIcon' + e.message);
      }
    })

    /**
     * 点击歌单播放
     */
    it('media_historicalList', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_playloopmode start');
        let historicalList = await driver.findComponent(ON.id('historical_list_item1'));
        expect(historicalList).not().assertUndefined();
        await historicalList.click();
        hilog.info(0x0, TAG, 'controller_itemswipedown end');
        await driver.delayMs(8000);
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'media_historicalList' + e.message);
      }
    })

    /**
     * kill com.ohos.music
     */
    it('media_uninstallapp', 0, async (done: Function) => {
      try {
        await driver.delayMs(3000);
        hilog.info(0x0, TAG, 'media_uninstallapp start');
        await stopApplication('com.ohos.himovie');
        expect(true).assertTrue();
        hilog.info(0x0, TAG, 'media_uninstallapp end');
        await driver.delayMs(5000);
        done();
      } catch(e) {
        hilog.info(0x0, TAG, 'media_uninstallapp' + e.message);
      }
    })
  })
}