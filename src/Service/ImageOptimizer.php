<?php
// src/Service/ImageOptimizer.php
namespace App\Service;

use Imagine\Gd\Imagine;
use Imagine\Image\Box;

class ImageOptimizer
{
public function reduceQuality(string $imagePath): void
{
$imagine = new Imagine();
$image   = $imagine->open($imagePath);

// Réduire la qualité à 70%
$image->save($imagePath, ['quality' => 70]);
}
}
