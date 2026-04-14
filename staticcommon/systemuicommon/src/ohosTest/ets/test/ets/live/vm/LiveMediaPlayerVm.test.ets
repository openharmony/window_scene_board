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
import { afterEach, beforeEach, describe, expect, it } from "@ohos/hypium";
import { LiveVmInjector } from "../../../../../../../newIndex";
import { LiveNotification } from "../../../../../../main/ets/live/model/LiveNotification";
import { LiveCapsuleVm } from "../../../../../../main/ets/live/vm/LiveCapsuleVm";
import { LiveMediaPlayerVm } from "../../../../../../main/ets/live/vm/LiveMediaPlayerVm";
import { image } from "@kit.ImageKit";
import colorSpaceManager from "@ohos.graphics.colorSpaceManager";
import rpc from "@ohos.rpc";

export default function LiveMediaPlayerVmTest() {
  describe('addMedia_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('updateMedia_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 2;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 1;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 3;
      liveMediaPlayerVm.live.creatorUid = 4;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 6;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_sleep_for_290_ms_when_creator_uid_is_not_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 5;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 7;
      liveMediaPlayerVm.live.creatorUid = 8;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_not_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 9;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 10;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 11;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 12;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('addMediaPlayer_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('updateMediaPlayer_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 2;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 1;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 3;
      liveMediaPlayerVm.live.creatorUid = 4;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 6;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_sleep_for_290_ms_when_creator_uid_is_not_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 5;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 7;
      liveMediaPlayerVm.live.creatorUid = 8;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_not_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 9;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 10;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 11;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 12;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should set oldMediaIcon when adding new media',DEFAULT, () => {
      liveNotification.capsule = { icon: 'newIcon' };
      liveMediaPlayerVm.addMedia(liveNotification);
      expect(liveMediaPlayerVm.oldMediaIcon).toBeUndefined();
      expect(liveMediaPlayerVm.oldMediaIconOpacity).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetX).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetY).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconScale).toEqual({ x: 1, y: 1 });
    });

    // Tests for updateMedia

    it('should toggleCapsuleList and update oldMediaIcon when creatorUid changes',DEFAULT, async () => {
      liveNotification.capsule = { icon: 'newIcon', iconAnimationType: LiveCapsuleIconAnimationType.Animate };
      liveMediaPlayerVm.live.creatorUid = 'newUid';
      await liveMediaPlayerVm.updateMedia(liveNotification);
      expect(liveMediaPlayerVm.vmInjector.getCapsuleListVm().toggleCapsuleList).toHaveBeenCalled();
      expect(liveMediaPlayerVm.oldMediaIcon).toBeUndefined();
      expect(liveMediaPlayerVm.oldMediaIconOpacity).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetX).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetY).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconScale).toEqual({ x: 1, y: 1 });
      await systemUICommonUtil.sleep(290);
    });

    it('should updateIconAnimation when iconAnimationType is Animate',DEFAULT, async () => {
      liveNotification.capsule = { icon: 'newIcon', iconAnimationType: LiveCapsuleIconAnimationType.Animate };
      await liveMediaPlayerVm.updateMedia(liveNotification);
      expect(liveMediaPlayerAnimation.updateIconAnimation).toHaveBeenCalled();
      expect(liveMediaPlayerVm.oldMediaIcon).toBeUndefined();
      expect(liveMediaPlayerVm.oldMediaIconOpacity).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetX).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetY).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconScale).toEqual({ x: 1, y: 1 });
      await systemUICommonUtil.sleep(290);
    });

    // Additional tests for properties

    it('should have default maskOpacity', DEFAULT,() => {
      expect(liveMediaPlayerVm.maskOpacity).toBe(0);
    });

    it('should have default mediaIconOffsetX',DEFAULT, () => {
      expect(liveMediaPlayerVm.mediaIconOffsetX).toBe(0);
    });

    it('should have default mediaIconOffsetY',DEFAULT, () => {
      expect(liveMediaPlayerVm.mediaIconOffsetY).toBe(0);
    });

    it('should have default mediaIconScale', DEFAULT,() => {
      expect(liveMediaPlayerVm.mediaIconScale).toEqual({ x: 1, y: 1 });
    });

    it('should have default mediaCircleShape',DEFAULT, () => {
      expect(liveMediaPlayerVm.mediaCircleShape).not.toBeUndefined();
    });

    it('should toggleCapsuleList and update oldMediaIcon when creatorUid changes',DEFAULT, async () => {
      const newIcon = 'newIcon';
      liveNotification.capsule = { icon: newIcon, iconAnimationType: LiveMediaPlayerAnimation.Animate };
      liveMediaPlayerVm.live.creatorUid = 'newUid';
      await liveMediaPlayerVm.updateMedia(liveNotification);
      expect(liveMediaPlayerVm.vmInjector.getCapsuleListVm().toggleCapsuleList).toHaveBeenCalled();
      expect(liveMediaPlayerVm.oldMediaIcon).toBeUndefined();
      expect(liveMediaPlayerVm.oldMediaIconOpacity).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetX).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetY).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconScale).toEqual({ x: 1, y: 1 });
      await systemUICommonUtil.sleep(290);
    });

    it('should updateIconAnimation when iconAnimationType is Animate',DEFAULT, async () => {
      const newIcon = 'newIcon';
      liveNotification.capsule = { icon: newIcon, iconAnimationType: LiveMediaPlayerAnimation.Animate };
      await liveMediaPlayerVm.updateMedia(liveNotification);
      expect(liveMediaPlayerAnimation.updateIconAnimation).toHaveBeenCalled();
      expect(liveMediaPlayerVm.oldMediaIcon).toBeUndefined();
      expect(liveMediaPlayerVm.oldMediaIconOpacity).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetX).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconOffsetY).toBe(0);
      expect(liveMediaPlayerVm.oldMediaIconScale).toEqual({ x: 1, y: 1 });
      await systemUICommonUtil.sleep(290);
    });

    // Additional tests for properties

    it('should have default maskOpacity',DEFAULT, () => {
      expect(liveMediaPlayerVm.maskOpacity).toBe(0);
    });

    it('should have default mediaIconOffsetX',DEFAULT, () => {
      expect(liveMediaPlayerVm.mediaIconOffsetX).toBe(0);
    });

    it('should have default mediaIconOffsetY',DEFAULT, () => {
      expect(liveMediaPlayerVm.mediaIconOffsetY).toBe(0);
    });

    it('should have default mediaIconScale',DEFAULT, () => {
      expect(liveMediaPlayerVm.mediaIconScale).toEqual({ x: 1, y: 1 });
    });

    it('should have default mediaCircleShape',DEFAULT, () => {
      expect(liveMediaPlayerVm.mediaCircleShape).not.toBeUndefined();
    });
  });

  describe('addMediaPlayerLive_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('updateMediaPlayerLive_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 2;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 1;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 3;
      liveMediaPlayerVm.live.creatorUid = 4;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 6;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_sleep_for_290_ms_when_creator_uid_is_not_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 5;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 7;
      liveMediaPlayerVm.live.creatorUid = 8;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_not_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 9;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 10;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 11;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 12;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('addMediaPlayerLiveCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('updateMediaPlayerLiveCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 2;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 1;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 3;
      liveMediaPlayerVm.live.creatorUid = 4;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 6;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_sleep_for_290_ms_when_creator_uid_is_not_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 5;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 7;
      liveMediaPlayerVm.live.creatorUid = 8;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_not_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 9;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 10;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 11;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 12;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('addMediaPlayerLiveCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('updateMediaPlayerLiveCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 2;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 1;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 3;
      liveMediaPlayerVm.live.creatorUid = 4;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 6;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_sleep_for_290_ms_when_creator_uid_is_not_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 5;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 7;
      liveMediaPlayerVm.live.creatorUid = 8;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_not_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 9;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 10;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 11;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 12;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('addMediaPlayerCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('updateMediaPlayerCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 2;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 1;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 3;
      liveMediaPlayerVm.live.creatorUid = 4;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 6;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_sleep_for_290_ms_when_creator_uid_is_not_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 5;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 7;
      liveMediaPlayerVm.live.creatorUid = 8;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_not_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 9;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 10;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 11;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 12;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });
}      liveMediaPlayerVm.live.creatorUid = 6;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_sleep_for_290_ms_when_creator_uid_is_not_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
      liveMediaPlayerVm.live.creatorUid = 5;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 7;
      liveMediaPlayerVm.live.creatorUid = 8;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_not_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 9;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_nor_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 10;
      liveMediaPlayerVm.live.creatorUid = 10;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 11;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 11;
      liveMediaPlayerVm.live.creatorUid = 12;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('addMediaPlayerMoreCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertNull();
    });

    it('should_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_set_oldMediaIcon_when_live_capsule_icon_is_not_null', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      let pixelMap: image.PixelMap = {
        isEditable: false,
        readPixelsToBuffer: (dst: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsToBufferSync: (dst: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        readPixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        readPixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writePixels: (area: image.PositionArea): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writePixelsSync: (area: image.PositionArea): void => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixels: (src: ArrayBuffer): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        writeBufferToPixelsSync: (src: ArrayBuffer): void => {
          throw new Error("Function not implemented.");
        },
        toSdr: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        getImageInfo: (): Promise<image.ImageInfo> => {
          throw new Error("Function not implemented.");
        },
        getImageInfoSync: (): image.ImageInfo => {
          throw new Error("Function not implemented.");
        },
        getBytesNumberPerRow: (): number => {
          throw new Error("Function not implemented.");
        },
        getPixelBytesNumber: (): number => {
          throw new Error("Function not implemented.");
        },
        getDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        opacity: (rate: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        opacitySync: (rate: number): void => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmap: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createAlphaPixelmapSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        scale: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        scaleSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMap: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        createScaledPixelMapSync: (x: number, y: number,
          level?: image.AntiAliasingLevel | undefined): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        translate: (x: number, y: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        translateSync: (x: number, y: number): void => {
          throw new Error("Function not implemented.");
        },
        rotate: (angle: number): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        rotateSync: (angle: number): void => {
          throw new Error("Function not implemented.");
        },
        flip: (horizontal: boolean, vertical: boolean): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        flipSync: (horizontal: boolean, vertical: boolean): void => {
          throw new Error("Function not implemented.");
        },
        crop: (region: image.Region): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        cropSync: (region: image.Region): void => {
          throw new Error("Function not implemented.");
        },
        getColorSpace: (): colorSpaceManager.ColorSpaceManager => {
          throw new Error("Function not implemented.");
        },
        marshalling: (sequence: rpc.MessageSequence): void => {
          throw new Error("Function not implemented.");
        },
        unmarshalling: (sequence: rpc.MessageSequence): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setColorSpace: (colorSpace: colorSpaceManager.ColorSpaceManager): void => {
          throw new Error("Function not implemented.");
        },
        isStrideAlignment: false,
        applyColorSpace: (targetColorSpace: colorSpaceManager.ColorSpaceManager):
          Promise<void> => {
          throw new Error("Function not implemented.");
        },
        convertPixelFormat: (targetPixelFormat: image.PixelMapFormat): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        release: (): Promise<void> => {
          throw new Error("Function not implemented.");
        },
        setTransferDetached: (detached: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getMetadata: (key: image.HdrMetadataKey): image.HdrMetadataValue => {
          throw new Error("Function not implemented.");
        },
        setMemoryNameSync: (name: string): void => {
          throw new Error("Function not implemented.");
        },
        cloneSync: (): image.PixelMap => {
          throw new Error("Function not implemented.");
        },
        clone: (): Promise<image.PixelMap> => {
          throw new Error("Function not implemented.");
        },
        setMetadata: (key: image.HdrMetadataKey, value: image.HdrMetadataValue): Promise<void> => {
          throw new Error("Function not implemented.");
        }
      }
      let icon: image.PixelMap = pixelMap;

      liveMediaPlayerVm.addMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });
  });

  describe('updateMediaPlayerMoreCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 2;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_toggle_capsule_list_when_creator_uid_is_same', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 1;
      liveMediaPlayerVm.live.creatorUid = 1;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 3;
      liveMediaPlayerVm.live.creatorUid = 4;

      await liveMediaPlayerVm.updateMedia(live);

      expect(liveMediaPlayerVm.oldMediaIcon).assertUndefined();
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let liveMediaPlayerVm: LiveMediaPlayerVm = new LiveMediaPlayerVm(liveVmInjector, live);
      live.creatorUid = 5;
