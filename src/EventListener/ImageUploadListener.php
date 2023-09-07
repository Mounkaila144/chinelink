<?php
// src/EventListener/ImageUploadListener.php
namespace App\EventListener;

use Vich\UploaderBundle\Event\Event;
use App\Service\ImageOptimizer;

class ImageUploadListener
{
    private $imageOptimizer;

    public function __construct(ImageOptimizer $imageOptimizer)
    {
        $this->imageOptimizer = $imageOptimizer;
    }

    public function onVichUploaderPostUpload(Event $event)
    {
        $object = $event->getObject();
        $mapping = $event->getMapping();

        $filePath = $mapping->getUploadDestination() . '/' . $mapping->getFileName($object);
        $this->imageOptimizer->reduceQuality($filePath);
    }
}
